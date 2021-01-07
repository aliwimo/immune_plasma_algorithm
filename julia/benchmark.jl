
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