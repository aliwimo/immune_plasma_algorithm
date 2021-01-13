import numpy as np

# bounds +/- 100
# maximum evaluations 150,000
def sphere(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        total_sum += (x[i] ** 2)
    return total_sum

# bounds +/- 32
# maximum evaluations 150,000
def ackley(x):
    D = len(x)
    a = 20
    b = 0.2
    c = 2 * np.pi
    sum1 = 0
    sum2 = 0
    for i in range(D):
        sum1 += (x[i] ** 2)
        sum2 += np.cos(c * x[i])
    term1 = -a * np.exp(-b * np.sqrt(sum1 / D))
    term2 = -np.exp(sum2 / D)
    return term1 + term2 + a + np.exp(1)

# bounds +/- 600
# maximum evaluations 200,000
def griewank(x):
    D = len(x)
    total_sum = 0
    total_prod = 1
    for i in range(D):
        total_sum += ((x[i] ** 2) / 4000)
        total_prod *= np.cos(x[i] / np.sqrt(i + 1))
    return total_sum - total_prod + 1

# bounds +/- 1.28
# maximum evaluations 300,000
def quartic(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        total_sum += i * (x[i] ** 4)
    return total_sum + np.random.rand()

# bounds +/- 5.12
# maximum evaluations 300,000
def rastrigin(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        total_sum += ((x[i] ** 2) - (10 * np.cos(2 * np.pi * x[i])) + 10)
    return total_sum

# bounds +/- 30
# maximum evaluations 500,000
def rosenbrock(x):
    D = len(x)
    total_sum = 0
    for i in range(D - 1):
        total_sum += 100 * (x[i + 1] - x[i] ** 2) ** 2 + (x[i] - 1) ** 2
    return total_sum

# bounds +/- 10
# maximum evaluations 200,000
def schwefel_2_22(x):
    D = len(x)
    total_sum = 0
    total_prod = 1
    for i in range(D):
        total_sum += abs(x[i])
        total_prod *= abs(x[i])
    return total_sum + total_prod

# bounds +/- 500
# maximum evaluations 300,000
def schwefel(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        total_sum += x[i] * np.sin( np.sqrt( abs( x[i] ) ) )
    return -total_sum

# bounds +/- 100
# maximum evaluations 150,000
def step(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        total_sum += ((np.floor(x[i] + 0.5)) ** 2)
    return total_sum

# bounds +/- 100
# maximum evaluations 500,000
def schwefel_2_21(x):
    D = len(x)
    max_value = abs(x[1])
    for i in range(D):
        if abs(x[i]) > max_value:
            max_value = abs(x[i])
    return max_value

# bounds +/- 100
# maximum evaluations 500,000
def schwefel_1_2(x):
    D = len(x)
    total_sum = 0
    for i in range(D):
        inner_sum = 0
        for j in range(i):
            inner_sum += x[j]
        total_sum += inner_sum ** 2
    return total_sum