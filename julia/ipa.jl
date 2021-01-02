

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

pop = generate_population()


println(pop)



println("---------------------------------------")