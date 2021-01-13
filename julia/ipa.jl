using Distributions
using Printf
using Dates

# importing benchmark functions' file
include("benchmark.jl")

# start timer
start_time = Dates.now()

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

    # start of infection phase
    for index = 1:population_size
        if current_evaluation < maximum_evaluations
            global current_evaluation += 1
            random_index = rand(1:population_size)
            while random_index == index
                random_index = rand(1:population_size)
            end
            current_individual = population[index, :]
            random_individual = population[random_index, :]
            infected_individual = perform_infection(current_individual, random_individual)
            fitness_of_infected = fitness(infected_individual)
            if fitness_of_infected < fitnesses[index]
                population[index, :] = copy(infected_individual)
                fitnesses[index] = fitness_of_infected
                compare_with_best_fitness(infected_individual)
            end
        else
            break # if exceeded maximum evaluation number
        end
    end

    # start of plasma transfering phase
    # generating dose_control and treatment_control vectors
    dose_control = ones(Int64, receivers_number)
    treatment_control = ones(Int64, receivers_number)

    # get indexes of both of donors and receivers
    donors_indexes, receivers_indexes = get_donors_and_receivers_indexes(fitnesses)
    
    for i = 1:receivers_number
        receiver_index = receivers_indexes[i]
        random_donor_index = donors_indexes[Int(rand(1:donors_number))]
        current_receiver = population[receiver_index, :]
        random_donor = population[random_donor_index, :]
        while treatment_control[i] == 1
            if current_evaluation < maximum_evaluations
                global current_evaluation += 1
                treated_individual = perform_plasma_transfer(current_receiver, random_donor)
                treated_fitness = fitness(treated_individual)
                if dose_control[i] == 1
                    if treated_fitness < fitnesses[random_donor_index]
                        dose_control[i] += 1
                        population[receiver_index, :] = copy(treated_individual)
                        fitnesses[receiver_index] = treated_fitness
                    else
                        population[receiver_index, :] = copy(random_donor)
                        fitnesses[receiver_index] = fitnesses[random_donor_index]
                        treatment_control[i] = 0
                    end
                else
                    if treated_fitness < fitnesses[receiver_index]
                        population[receiver_index, :] = copy(treated_individual)
                        fitnesses[receiver_index] = treated_fitness
                    else
                        treatment_control[i] = 0
                    end
                end
                compare_with_best_fitness(population[receiver_index, :])
            else
                break # if exceeded maximum evaluation number
            end
        end
    end

    # start of donors updating phase
    for i = 1:donors_number
        if current_evaluation < maximum_evaluations
            global current_evaluation += 1
            donor_index = donors_indexes[i]
            if (current_evaluation / maximum_evaluations) > rand()
                population[donor_index, :] = update_donor(population[donor_index, :])
            else
                population[donor_index, :] = generate_individual()
            end
            fitnesses[donor_index] = fitness(population[donor_index, :])
            compare_with_best_fitness(population[donor_index, :])
        else
            break # if exceeded maximum evaluation number
        end
    end
end

# print elapsed time
end_time = Dates.now()
total_time = (Dates.value(end_time) - Dates.value(start_time)) / 1000
@printf("Elapsed time: %.2f seconds\n", total_time)

# print best fitness value in scientific notation
@printf("Best fitness value: %.6e\n", best_fitness)
