clc;
clear;

% global variables and parameteres
global pop_size; 
global dim_size;
global NoD;
global NoR;
pop_size = 30;
dim_size = 30;
NoD = 1;
NoR = 1;
t_max = 150000;
t_cr = pop_size;
bound = 100;

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


while t_cr < t_max
    
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
            x_k_inf_fit = fitness(x_k_inf);
            if x_k_inf_fit < fitnesses(k)
                population(k, :) = x_k_inf;
                fitnesses(k) = x_k_inf_fit;
                if fitnesses(k) < x_best_fit
                    x_best = population(k, :);
                    x_best_fit = fitnesses(k);
                end
            end
        else
            break;
        end
        
    end
    
    % plasma transfer
    dose_control = ones(NoR, 1);
    [d_indexes, r_indexes] = get_donors_recievers(fitnesses);
    treatment_control = ones(NoR, 1);
    for i = 1:NoR
        k = r_indexes(i);
        idx = randperm(length(d_indexes),1);
        m = d_indexes(idx);
        while treatment_control(i) == 1
            if t_cr < t_max
                t_cr = t_cr + 1;
                x_k_rcv_p = give_plasma(population(k, :), population(m, :));
                x_k_rcv_p_fit = fitness(x_k_rcv_p);
                if dose_control(i) == 1
                    if x_k_rcv_p_fit < fitnesses(m)
                        dose_control(i) = dose_control(i) + 1;
                        population(k, :) = x_k_rcv_p;
                        fitnesses(k) = x_k_rcv_p_fit;
                    else
                        population(k, :) = population(m, :);
                        fitnesses(k) = fitnesses(m);
                        treatment_control(i) = 0;
                    end
                else
                    if x_k_rcv_p_fit < fitnesses(k)
                        population(k, :) = x_k_rcv_p;
                        fitnesses(k) = x_k_rcv_p_fit;
                    else
                        treatment_control(i) = 0;
                    end
                end
                if fitnesses(k) < x_best_fit
                    x_best = population(k, :);
                    x_best_fit = fitnesses(k);
                end
            else
                break;
            end
        end
    end
    
    % donor update
    for i = 1:NoD
        if t_cr < t_max
            t_cr = t_cr + 1;
            m = d_indexes(i);
            x_m_dnr = population(m, :);
            if (t_cr / t_max) < rand()
                x_m_dnr = update_donor(x_m_dnr);
                population(m, :) = x_m_dnr;
            else
                for j = 1:dim_size
                    population(m, j) = bound + (rand() * (bound - -bound));
                end
            end
            fitnesses(m) = fitness(population(m, :));
            
            if fitnesses(m) < x_best_fit
                x_best = population(m, :);
                x_best_fit = fitnesses(m);
            end
            
        else
            break;
        end
    end
    
end

disp(t_cr);
disp(x_best_fit);

% ----------------------------------------------------- %
% --------------------- FUNCTIONS --------------------- %
% ----------------------------------------------------- %   

function pop = generate_population(LB, UB)
    global pop_size;
    global dim_size;
    pop = zeros(pop_size, 1);
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

% get lists of indexes of donors and recievers
function [d_indexes, r_indexes] = get_donors_recievers(fitnesses)
    global NoD;
    global NoR;
    d_indexes = zeros(NoD, 1);
    r_indexes = zeros(NoR, 1);
    [~, sorted_indexes] = sort(fitnesses);
    for i = 1:NoD
        d_indexes(i) = sorted_indexes(i);
    end
    for i = 1:NoR
        r_indexes(i) = sorted_indexes(end - (i - 1));
    end
end

function x_k_rcv = give_plasma(x_k_rcv, x_m_dnr)
    global dim_size;
    for j = 1:dim_size
        rnd = -1 + 2.*rand();
        x_k_rcv(j) = x_k_rcv(j) + rnd * (x_k_rcv(j) - x_m_dnr(j));
    end
end

% update donor with equation 5
function x_m_dnr = update_donor(x_m_dnr)
    global dim_size;
    for j = 1:dim_size
        rnd = -1 + 2.*rand();
        x_m_dnr(j) = x_m_dnr(j) + rnd * x_m_dnr(j);
    end
end