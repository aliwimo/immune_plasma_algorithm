clc;
clear;

% global variables and parameteres
global pop_size; 
global dim_size;
global NoD;
global NoR;
pop_size = 5;
dim_size = 3;
NoD = 1;
NoR = 1;
t_max = 500;
t_cr = pop_size;
bound = 10;

% generating initial population
population = generate_population(-bound, bound);

% calculating fitness of population
fitnesses = zeros(pop_size, 1);
for i = 1:pop_size
   fitnesses(i) = fitness(population(i, :)); 
end

% finding best individual
[x_best_fit, x_best_index] = min(fitnesses);
x_best = population(x_best_index, :);


% x_k = population(1, :);
% x_n = population(1, :);
% x_m = population(2, :);
% x_k_inf = infect(x_k, x_m);

% while t_cr < t_max
while t_cr > t_max
    
    % infection distribution
    for k = 1:pop_size
        if t_cr < t_max
            t_cr = t_cr + 1;
            m = randi([1 pop_size]);
            while m == k
            	m = randi([1 pop_size]);
            end
            x_k = population(k, :);
            x_m = population(m, :);
            x_k_inf = infect(x_k, x_m);
            
        else
            break;
        end
    end
    
    
end


% ----------------------------------------------------- %
% --------------------- FUNCTIONS --------------------- %
% ----------------------------------------------------- %   

function pop = generate_population(LB, UB)
    global pop_size;
    global dim_size;
    pop = zeros(pop_size, dim_size);
    for k = 1:pop_size
        for j = 1:dim_size
            pop(k, j) = LB + (rand() * (UB - LB));
        end
    end
end

% sphere function
function fit = fitness(x)
    fit = sumsqr(x(1,:));
end

function x_k = infect(x_k, x_m)
    global dim_size;
    j = randi([1 dim_size]);
    rnd = -1 + 2.*rand();
    x_k(j) = x_k(j) + rnd * (x_k(j) - x_m(j));
end


