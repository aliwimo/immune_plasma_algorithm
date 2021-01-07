

function sphere(x)
    D = length(x)
    sum = 0
    for i = 1:D
        sum += (x[i]^2)
    end
    return sum
end