using Distributions
println("---------------------------------------")


pop_size = 5
dim_size = 3
t_max = 10000
t_cr = pop_size
bound = 100
LB = -bound
UB = bound
NoD = 1
NoR = 3

function generate_population()
    population = zeros(pop_size, dim_size)
    for k = 1:pop_size
        for j = 1:dim_size
            population[k, j] = LB + rand() * (UB - LB)
        end
    end
    return population
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
    x_k[j] += rand(Uniform(-1, 1)) * (x_k[j] - x_m[j])
    return x_k
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
    x = zeros(1, dim_size)
    for j = 1:dim_size
        x[j] = x_k_rcv[j] + rand(Uniform(-1, 1)) * (x_k_rcv[j] - x_m_dnr[j])
    end
    return x
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

println(x_best_fit)


# while t_cr < t_max
if 1 == 1

    # infection distirbution
    for k = 1:pop_size
        if t_cr < t_max
            global t_cr += 1
            m = rand(1:pop_size)
            while m == k
                m = rand(1:pop_size)
            end
            x_k = copy(population[k, :])
            x_m = copy(population[m, :])
            x_k_inf = infect(x_k, x_m)
            x_k_inf_fit = fitness(x_k_inf)
            if x_k_inf_fit < fitnesses[k]
                population[k, :] = copy(x_k_inf)
                fitnesses[k] = x_k_inf_fit
                if x_k_inf_fit < x_best_fit
                    global x_best = copy(x_k_inf)
                    global x_best_fit = x_k_inf_fit
                    println(x_best_fit)
                end
            end
        else
            break
        end
    end

    # plasma transfer
    dose_control = ones(NoR)
    d_indexes, r_indexes = get_donors_receivers(fitnesses)
    treatment_control = ones(NoR)
    for i = 1:NoR
        k = r_indexes[i]
        m = Int(rand(1:NoD))
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

                if fitnesses[k] < x_best_fit
                    global x_best = copy(population[k, :])
                    global x_best_fit = fitnesses[k]
                    println(x_best_fit)
                end
            else
                break
            end
        end
    end


end

println("---------------------------------------")

