% ===================================================== %
% Implementation of Immune Plasma Algorithm (IPA)       %
% Introduced by Selcuk Aslan and Sercan Demirci in 2020 %
% Published at:                                         %
% https://ieeexplore.ieee.org/document/9285244          %
% ===================================================== %


clc;
clear;

% importing benchmark functions
addpath('./benchmark/');

% initlizing global variables
global objective_function;
global population_size; 
global dimension_size;
global donors_number;
global receivers_number;
global lower_bound;
global upper_bound;

% set objective function from the list in "benchmark" directory
objective_function = @ackley;

% set initial parameters' values
population_size = 30;
dimension_size = 30;
donors_number = 3;
receivers_number = 3;
maximum_evaluations = 150000;
bounds = [-30, 30];

% other dependent parameters, no need to change
current_evaluation = population_size;
lower_bound = bounds(1);
upper_bound = bounds(2);


% ----------------------------------------------------- %
% ---------------- START OF ALGORITHM ----------------- %
% ----------------------------------------------------- %   
% start timer
tic

% generating initial population
population = generate_population(lower_bound, upper_bound);

% calculating fitness of population
fitnesses = calculate_fitnesses(population);

% finding best individual fitness
global best_fitness
best_fitness = min(fitnesses);

% print initial best fitness value and other statistics
fprintf('Initial best fitness value: %d\n', best_fitness);
fprintf('Number of parameters: %d\n', dimension_size);
fprintf('Population size: %d\n', population_size);


while current_evaluation < maximum_evaluations
    
    
    % start of infection phase
    for index = 1:population_size
        if current_evaluation < maximum_evaluations
            current_evaluation = current_evaluation + 1;
            random_index = get_random_index_of(population);
            while random_index == index
            	random_index = get_random_index_of(population);
            end
            x_k = population(index, :);
            x_m = population(random_index, :);
            infected_individual = perform_infection(x_k, x_m);
            fitness_of_infected = fitness(infected_individual);
            if fitness_of_infected < fitnesses(index)
                population(index, :) = infected_individual;
                fitnesses(index) = fitness_of_infected;
                compare_with_best_fitness(infected_individual);
            end
        else
            break; % if exceeded maximum evaluation number
        end
    end
    
    
    
    % start of plasma transfering phase
    % generating dose_control and treatment_control vectors
    dose_control = ones(receivers_number, 1);
    treatment_control = ones(receivers_number, 1);
    
    % get indexes of both of donors and receivers
    [donors_indexes, receivers_indexes] = get_donors_and_receivers_indexes(fitnesses);
    
    for i = 1:receivers_number
        receiver_index = receivers_indexes(i);
        
        % finding random indvidual of donors list
        donor_index = donors_indexes(get_random_index_of(donors_indexes));
        
        while treatment_control(i) == 1
            if current_evaluation < maximum_evaluations
                current_evaluation = current_evaluation + 1;
                treated_individual = perform_plasma_transfer(population(receiver_index, :), population(donor_index, :));
                treated_fitness = fitness(treated_individual);
                if dose_control(i) == 1
                    if treated_fitness < fitnesses(donor_index)
                        dose_control(i) = dose_control(i) + 1;
                        population(receiver_index, :) = treated_individual;
                        fitnesses(receiver_index) = treated_fitness;
                    else
                        population(receiver_index, :) = population(donor_index, :);
                        fitnesses(receiver_index) = fitnesses(donor_index);
                        treatment_control(i) = 0;
                    end
                else
                    if treated_fitness < fitnesses(receiver_index)
                        population(receiver_index, :) = treated_individual;
                        fitnesses(receiver_index) = treated_fitness;
                    else
                        treatment_control(i) = 0;
                    end
                end
                compare_with_best_fitness(population(receiver_index, :));
            else
                break; % if exceeded maximum evaluation number
            end
        end
    end
    
    
    
    % start of donors updating phase
    for i = 1:donors_number
        if current_evaluation < maximum_evaluations
            current_evaluation = current_evaluation + 1;
            donor_index = donors_indexes(i);
            if (current_evaluation / maximum_evaluations) > rand()
                population(donor_index, :) = update_donor(population(donor_index, :));
            else
                population(donor_index, :) = generate_individual(lower_bound, upper_bound);
            end
            fitnesses(donor_index) = fitness(population(donor_index, :));
            compare_with_best_fitness(population(donor_index, :));
        else
            break; % if exceeded maximum evaluation number
        end
    end
    
end
% end of run

% print initial best fitness value
fprintf('Best fitness value: %d\n', best_fitness);

% stop timer
toc

% ----------------------------------------------------- %
% --------------------- FUNCTIONS --------------------- %
% ----------------------------------------------------- %   

% generating the initial population
function population = generate_population(LB, UB)
    global population_size;
    global dimension_size;
    population = zeros(population_size, dimension_size);
    for k = 1:population_size
        population(k, :) = generate_individual(LB, UB);
    end
end

% generating just one individual
function individual = generate_individual(UB, LB)
    global dimension_size;
    individual = zeros(1, dimension_size);
    for j = 1:dimension_size
        individual(1, j) = LB + (rand() * (UB - LB));
    end 
end

% calculating fitness of all individuals in population
function fitnesses = calculate_fitnesses(population)
    global population_size;
    fitnesses = zeros(population_size, 1);
    for i = 1:population_size
       fitnesses(i) = fitness(population(i, :)); 
    end
end

% calculation fitness for one individual
function fit = fitness(x)
    global objective_function;
    fit = objective_function(x);
end

% returns a random index of range 1 to length(x)
function index = get_random_index_of(x)
    index = randi([1 length(x)]);
end

% perform infection between two individuals
function k = perform_infection(k, m)
    global dimension_size;
    j = randi([1 dimension_size]);
    rnd = -1 + 2.*rand();
    k(j) = k(j) + rnd * (k(j) - m(j));
    k(j) = check_bounds(k(j));
end

% check if exceeded bounds
function y = check_bounds(x)
    global lower_bound;
    global upper_bound;
    if x > upper_bound
        x = upper_bound;
    elseif x < lower_bound
        x = lower_bound;
    end
    y = x;
end

% get lists of indexes of doreceivers_numbers and recievers
function [donors, receivers] = get_donors_and_receivers_indexes(fitnesses)
    global donors_number;
    global receivers_number;
    donors = zeros(donors_number, 1);
    receivers = zeros(receivers_number, 1);
    [~, sorted_indexes] = sort(fitnesses);
    for i = 1:donors_number
        donors(i) = sorted_indexes(i);
    end
    for i = 1:receivers_number
        receivers(i) = sorted_indexes(end - (i - 1));
    end
end

% performing plasma tranfer from donor to receiver indvidual
function x_k_rcv = perform_plasma_transfer(x_k_rcv, x_m_dnr)
    global dimension_size;
    for j = 1:dimension_size
        rnd = -1 + 2.*rand();
        x_k_rcv(j) = x_k_rcv(j) + rnd * (x_k_rcv(j) - x_m_dnr(j));
        x_k_rcv(j) = check_bounds(x_k_rcv(j));
    end
end

% updating donor's parameters
function x_m_dnr = update_donor(x_m_dnr)
    global dimension_size;
    for j = 1:dimension_size
        rnd = -1 + 2.*rand();
        x_m_dnr(j) = x_m_dnr(j) + rnd * x_m_dnr(j);
        x_m_dnr(j) = check_bounds(x_m_dnr(j));
    end
end

% compare with best
function compare_with_best_fitness(x)
    global best_fitness
    if fitness(x) < best_fitness
        best_fitness = fitness(x);
    end
end
