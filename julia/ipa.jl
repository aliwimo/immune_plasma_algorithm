

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

pop = generate_population()

# calculating fitness of population
fitnesses = zeros(pop_size)
for i = 1:pop_size
    fitnesses[i] = fitness(pop[i, :])
end

println(pop)
println(fitnesses)


println("---------------------------------------")