using Distributions

# importing benchmark functions' file
include("benchmark.jl")

# set objective function from the list in "benchmark" file
objective_function = sphere

# set initial parameters' values
population_size = 30
dimension_size = 30
donors_number = 1
receivers_number = 1
maximum_evaluations = 150000
bound = 100

# other dependent parameters, no need to change
current_evaluation = population_size
lower_bound = -bound
upper_bound = bound

# ========================================================= #
#                       Functions                           #
# ========================================================= #

# generating the initial population
function generate_population()
    population = zeros(population_size, dimension_size)
    for k = 1:population_size
        population[k, :] = generate_individual()
    end
    return population
end

# generating just one individual
function generate_individual()
    individual = zeros(1, dimension_size)
    for i = 1:dimension_size
        individual[1, i] = lower_bound + rand() * (upper_bound - lower_bound)
    end
    return individual
end

# calculating fitness of all individuals in population
function calculate_fitnesses(population)
    fitnesses = zeros(population_size)
    for i = 1:population_size
        fitnesses[i] = fitness(population[i, :])
    end
    return fitnesses
end

# calculation fitness for one individual
function fitness(individual)
    return objective_function(individual)
end

# perform infection between two individuals
function perform_infection(x_k, x_m)
    j = rand(1:dimension_size)
    x = copy(x_k)
    x[j] = x_k[j] + (rand(Uniform(-1.0, 1.0)) * (x_k[j] - x_m[j]))
    x[j] = check_bounds(x[j])
    return x
end

# check if exceeded bounds
function check_bounds(x)
    if x > upper_bound
        x = upper_bound
    elseif x < lower_bound
        x = lower_bound
    end
    return x
end

# get lists of indexes of doreceivers_numbers and recievers
function get_donors_and_receivers_indexes(fitnesses)
    donors = zeros(Int64, donors_number)
    receivers = zeros(Int64, receivers_number)
    sorted_indexes = sortperm(fitnesses)
    for i = 1:donors_number
        donors[i] = sorted_indexes[i]
    end
    reverse!(sorted_indexes)
    for i = 1:receivers_number
        receivers[i] = sorted_indexes[i]
    end
    return donors, receivers
end

# performing plasma tranfer from donor to receiver indvidual
function perform_plasma_transfer(receiver, donor)
    for j = 1:dimension_size
        receiver[j] += rand(Uniform(-1, 1)) * (receiver[j] - donor[j])
        receiver[j] = check_bounds(receiver[j])
    end
    return receiver
end

# updating donor's parameters
function update_donor(donor)
    for j = 1:dimension_size
        donor[j] += rand(Uniform(-1, 1)) * donor[j]
        donor[j] = check_bounds(donor[j])
    end
    return donor
end

# compare individual's fitness with global fitness value
function compare_with_best_fitness(x)
    if fitness(x) < best_fitness
        global best_fitness = fitness(x)
    end
end

# ========================================================= #
#                      Start of IPA                         #
# ========================================================= #

# generating initial population
population = generate_population()

# calculating fitness of population
fitnesses = calculate_fitnesses(population)


# finding best individual fitness
best_fitness = minimum(fitnesses)

# print initial best fitness value and other statistics
println("Initial best fitness value: $best_fitness")
println("Number of parameters: $dimension_size")
println("Population size: $population_size")

while current_evaluation < maximum_evaluations

    # perform_infectionion distirbution
    for k = 1:population_size
        if current_evaluation < maximum_evaluations
            global current_evaluation += 1
            m = rand(1:population_size)
            while m == k
                m = rand(1:population_size)
            end
            x_k = population[k, :]
            x_m = population[m, :]
            x_k_inf = perform_infection(population[k, :], population[m, :])
            x_k_inf_fit = fitness(x_k_inf)
            if x_k_inf_fit < fitnesses[k]
                population[k, :] = copy(x_k_inf)
                fitnesses[k] = x_k_inf_fit
                compare_with_best_fitness(x_k_inf)
            end
        else
            break
        end
    end

    # plasma transfer
    dose_control = ones(Int64, receivers_number)
    d_indexes, r_indexes = get_donors_and_receivers_indexes(fitnesses)
    treatment_control = ones(Int64, receivers_number)
    for i = 1:receivers_number
        k = r_indexes[i]
        m = d_indexes[Int(rand(1:donors_number))]
        while treatment_control[i] == 1
            if current_evaluation < maximum_evaluations
                global current_evaluation += 1
                x_k_rcv_p = perform_plasma_transfer(population[k, :], population[m, :])
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
                compare_with_best_fitness(population[k, :])
            else
                break
            end
        end
    end

    # Donor update
    for i = 1:donors_number
        if current_evaluation < maximum_evaluations
            global current_evaluation += 1
            m = d_indexes[i]
            x_m_dnr = copy(population[m, :])
            if (current_evaluation / maximum_evaluations) > rand()
                x_m_dnr = update_donor(x_m_dnr)
                population[m, :] = copy(x_m_dnr)
            else
                for j = 1:dimension_size
                    population[m, j] = lower_bound + rand() * (upper_bound - lower_bound)
                end
            end
            fitnesses[m] = fitness(population[m, :])
            compare_with_best_fitness(population[m, :])
        else
            break
        end
    end
end

println("Best: $best_fitness")
