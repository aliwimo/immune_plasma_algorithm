# bounds +/- 100
# maximum evaluations 150,000
function sphere(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += (x[i]^2)
    end
    return sum
end

# bounds +/- 32
# maximum evaluations 150,000
function ackley(x)
    D = length(x)
    a = 20
    b = 0.2
    c = 2 * pi
    sum1 = 0
    sum2 = 0
    for i = 1:D
        sum1 += (x[i]^2)
        sum2 += cos(c * x[i])
    end
    term1 = -a * exp(-b * sqrt(sum1 / D))
    term2 = -exp(sum2 / D)
    return term1 + term2 + a + exp(1)
end

# bounds +/- 600
# maximum evaluations 200,000
function griewank(x)
    D = length(x)
    sum = 0
    prod = 1
    for i = 1:D
        sum += ((x[i]^2) / 4000)
        prod *= cos(x[i] / sqrt(i))
    end
    return sum - prod + 1
end

# bounds +/- 1.28
# maximum evaluations 300,000
function quartic(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += i * (x[i]^4)
    end
    return sum + rand()
end

# bounds +/- 5.12
# maximum evaluations 300,000
function rastrigin(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += (x[i]^2 - (10 * cos(2 * pi * x[i])) + 10)
    end
    return sum
end

# bounds +/- 30
# maximum evaluations 500,000
function rosenbrock(x)
    D = length(x)
    sum = 0
    for i = 1:(D - 1)
        sum += 100 * (x[i + 1] - x[i]^2)^2 + (x[i] - 1)^2
    end
    return sum
end

# bounds +/- 10
# maximum evaluations 200,000
function schwefel_2_22(x)
    D = length(x)
    sum = 0
    prod = 1
    for i = 1:D
        sum += abs(x[i])
        prod *= abs(x[i])
    end
    return sum + prod
end

# bounds +/- 500
# maximum evaluations 300,000
function schwefel(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += x[i] * sin( sqrt( abs( x[i] ) ) )
    end
    return -sum
end

# bounds +/- 100
# maximum evaluations 150,000
function step(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += ((floor(x[i] + 0.5)) ^ 2)
    end
    return sum
end

# bounds +/- 100
# maximum evaluations 500,000
function schwefel_2_21(x)
    D = length(x)
    max_value = abs(x[1])
    for i = 2:D
        if abs(x[i]) > max_value
            max_value = abs(x[i])
        end
    end
    return max_value
end

# bounds +/- 100
# maximum evaluations 500,000
function schwefel_1_2(x)
    D = length(x)
    total_sum = 0
    for i = 1:D
        inner_sum = 0
        for j = 1:i
            inner_sum += x[j]
        end
        total_sum += inner_sum^2
    end
    return total_sum
end