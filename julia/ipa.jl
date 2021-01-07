using Distributions

pop_size = 30
dim_size = 30
t_max = 150000
t_cr = pop_size
bound = 100
LB = -bound
UB = bound
NoD = 1
NoR = 1

function generate_population()
    population = zeros(pop_size, dim_size)
    for k = 1:pop_size
        population[k, :] = generate_individual()
    end
    return population
end

function generate_individual()
    individual = zeros(1, dim_size)
    for i = 1:dim_size
        individual[1, i] = LB + rand() * (UB - LB)
    end
    return individual
end

function calculate_fitnesses(population)
    fitnesses = zeros(pop_size, 1)
    for i = 1:pop_size
        fitnesses[i] = fitness(population[i, :])
    end
    return fitnesses
end

function calculate_fitness(individual)
    # here will be something
end

function fitness(x)
    sum = 0
    for j = 1:dim_size
        sum += (x[j] ^ 2)
    end
    return sum
end

function infect(x_k, x_m)
    j = rand(1:dim_size)
    x = copy(x_k)
    x[j] = x_k[j] + (rand(Uniform(-1.0, 1.0)) * (x_k[j] - x_m[j]))
    return x
end

# get lists of indexes of donors and receivers
function get_donors_receivers(fitnesses)
    d_indexes = zeros(Int64, NoD)
    r_indexes = zeros(Int64, NoR)
    sorted_indexes = sortperm(fitnesses)
    for i = 1:NoD
        d_indexes[i] = sorted_indexes[i]
    end
    reverse!(sorted_indexes)
    for i = 1:NoR
        r_indexes[i] = sorted_indexes[i]
    end
    return d_indexes, r_indexes
end

# plasma donation to infected indiviual
function give_plasma(x_k_rcv, x_m_dnr)
    for j = 1:dim_size
        x_k_rcv[j] += rand(Uniform(-1, 1)) * (x_k_rcv[j] - x_m_dnr[j])
    end
    return x_k_rcv
end

# update donor with equation 5
function update_donor(x_m_dnr)
    for j = 1:dim_size
        x_m_dnr[j] += rand(Uniform(-1, 1)) * x_m_dnr[j]
    end
    return x_m_dnr
end

function compare_with_best(x)
    if fitness(x) < x_best_fit
        global x_best = copy(x)
        global x_best_fit = fitness(x)
        # println(x_best_fit)
    end
end


population = generate_population()

# calculating fitness of population
fitnesses = zeros(pop_size)
for i = 1:pop_size
    fitnesses[i] = fitness(population[i, :])
end


# find best individual among population
x_best_index = argmin(fitnesses)
x_best = copy(population[x_best_index, :])
x_best_fit = fitnesses[x_best_index]

println("Initial Best: $x_best_fit")

while t_cr < t_max

    # infection distirbution
    for k = 1:pop_size
        if t_cr < t_max
            global t_cr += 1
            m = rand(1:pop_size)
            while m == k
                m = rand(1:pop_size)
            end
            x_k = population[k, :]
            x_m = population[m, :]
            x_k_inf = infect(population[k, :], population[m, :])
            x_k_inf_fit = fitness(x_k_inf)
            if x_k_inf_fit < fitnesses[k]
                population[k, :] = copy(x_k_inf)
                fitnesses[k] = x_k_inf_fit
                compare_with_best(x_k_inf)
            end
        else
            break
        end
    end

    # plasma transfer
    dose_control = ones(Int64, NoR)
    d_indexes, r_indexes = get_donors_receivers(fitnesses)
    treatment_control = ones(Int64, NoR)
    for i = 1:NoR
        k = r_indexes[i]
        m = d_indexes[Int(rand(1:NoD))]
        while treatment_control[i] == 1
            if t_cr < t_max
                global t_cr += 1
                x_k_rcv_p = give_plasma(population[k, :], population[m, :])
                x_k_rcv_p_fit = fitness(x_k_rcv_p)
                if dose_control[i] == 1
                    if x_k_rcv_p_fit < fitnesses[m]
                        dose_control[i] += 1
                        population[k, :] = copy(x_k_rcv_p)
                        fitnesses[k] = x_k_rcv_p_fit
                    else
                        population[k, :] = copy(population[m, :])
                        fitnesses[k] = fitnesses[m]
                        treatment_control[i] = 0
                    end
                else
                    if x_k_rcv_p_fit < fitnesses[k]
                        population[k, :] = copy(x_k_rcv_p)
                        fitnesses[k] = x_k_rcv_p_fit
                    else
                        treatment_control[i] = 0
                    end
                end
                compare_with_best(population[k, :])
            else
                break
            end
        end
    end

    # Donor update
    for i = 1:NoD
        if t_cr < t_max
            global t_cr += 1
            m = d_indexes[i]
            x_m_dnr = copy(population[m, :])
            if (t_cr / t_max) > rand()
                x_m_dnr = update_donor(x_m_dnr)
                population[m, :] = copy(x_m_dnr)
            else
                for j = 1:dim_size
                    population[m, j] = LB + rand() * (UB - LB)
                end
            end
            fitnesses[m] = fitness(population[m, :])
            compare_with_best(population[m, :])
        else
            break
        end
    end
end

println("Best: $x_best_fit")
