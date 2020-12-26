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
pop = generate_population(-bound, bound);

% calculating fitness of population
fitnesses = zeros(pop_size, 1);
for i = 1:pop_size
   x = pop(i, :);
   fitnesses(i) = fitness(pop(i, :)); 
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


