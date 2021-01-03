import numpy as np
from random import choice, random
import benchmark

POP_SIZE    = 30
DIM_SIZE    = 30
T_MAX       = 150000
T_CR        = POP_SIZE
BOUND       = 100
LB          = -BOUND
UB          = BOUND
NoD         = 1
NoR         = 1
OBJ_FUNC    = benchmark.sphere

display_results = True


# generate population
def generate_population():
    return np.random.uniform(0, 1, (POP_SIZE, DIM_SIZE)) * (UB - LB) + LB

# calculate fitness
def fitness(x):
    return OBJ_FUNC(x)

# infect individual
def infect(x_k, x_m):
    j = np.random.randint(0, DIM_SIZE)
    x_k[j] += np.random.uniform(-1.0, 1.0) * (x_k[j] - x_m[j])
    return x_k

# plasma donation to infected indiviual
def give_plasma(x_k_rcv, x_m_dnr):
    for j in range(DIM_SIZE):
        x_k_rcv[j] += np.random.uniform(-1.0, 1.0) * (x_k_rcv[j] - x_m_dnr[j])
    return x_k_rcv


# get lists of indexes of donors and recievers
def get_donors_recievers(fitnesses):
    d_indexes = []
    r_indexes = []
    sorted_indexes = np.argsort(fitnesses)
    for i in range(NoD):
        d_indexes.append(sorted_indexes[i])
    for i in range(NoR):
        r_indexes.append(sorted_indexes[-1 - i])
    return d_indexes, r_indexes

# update donor with equation 5
def update_donor(x_m_dnr):
    for j in range(DIM_SIZE):
        x_m_dnr[j] += np.random.uniform(-1.0, 1.0) * x_m_dnr[j]
    return x_m_dnr


population = generate_population()
fitnesses = [fitness(i) for i in population]

x_best_index = fitnesses.index(min(fitnesses))
x_best = population[x_best_index].copy()
x_best_fit = fitnesses[x_best_index]


while T_CR < T_MAX:

    # infection distribution
    for k in range(POP_SIZE):
        if T_CR < T_MAX:
            T_CR += 1
            m = np.random.randint(0, POP_SIZE)
            while m == k:
                m = np.random.randint(0, POP_SIZE)
            x_k = population[k].copy()
            x_m = population[m].copy()
            x_k_inf = infect(x_k, x_m)
            x_k_inf_fit = fitness(x_k_inf)
            if x_k_inf_fit < fitnesses[k]:
                population[k] = x_k_inf.copy()
                fitnesses[k] = x_k_inf_fit
                if x_k_inf_fit < x_best_fit:
                    x_best = x_k_inf.copy()
                    x_best_fit = x_k_inf_fit
                    if display_results:
                        print(x_best_fit)
        else:
            break
    
    # plasma transfer
    dose_control = np.ones(NoR)
    d_indexes, r_indexes = get_donors_recievers(fitnesses)
    treatment_control = np.ones(NoR)
    for i in range(NoR):
        k = r_indexes[i]
        m = choice(d_indexes)            
        while treatment_control[i] == 1:
            if T_CR < T_MAX:
                T_CR += 1
                x_k_rcv_p = give_plasma(population[k], population[m])
                x_k_rcv_p_fit = fitness(x_k_rcv_p)
                if dose_control[i] == 1:
                    if x_k_rcv_p_fit < fitnesses[m]:
                        dose_control[i] += 1
                        population[k] = x_k_rcv_p.copy()
                        fitnesses[k] = x_k_rcv_p_fit
                    else:
                        population[k] = population[m].copy()
                        fitnesses[k] = fitnesses[m]
                        treatment_control[i] = 0
                else:
                    if x_k_rcv_p_fit < fitnesses[k]:
                        population[k] = x_k_rcv_p.copy()
                        fitnesses[k] = x_k_rcv_p_fit
                    else:
                        treatment_control[i] = 0
                
                if fitnesses[k] < x_best_fit:
                    x_best = population[k].copy()
                    x_best_fit = fitnesses[k]
                    if display_results:
                        print(x_best_fit)
            else:
                break

    # Donor update
    for i in range(NoD):
        if T_CR < T_MAX:
            T_CR += 1
            m = d_indexes[i]
            x_m_dnr = population[m].copy()
            if (T_CR / T_MAX) > random():
                x_m_dnr = update_donor(x_m_dnr)
                population[m] = x_m_dnr.copy()
            else:
                population[m] = np.random.uniform(0, 1, (DIM_SIZE)) * (UB - LB) + LB
            fitnesses[m] = fitness(population[m])
            
            if fitnesses[m] < x_best_fit:
                x_best = population[m].copy()
                x_best_fit = fitnesses[m]
                if display_results:
                    print(x_best_fit)
        else:
            break
            
print(x_best_fit)