function fit = step(x)
    dimension_size = length(x);
    total_sum = 0;
    for i = 1:dimension_size
        total_sum = total_sum + ((floor(x(i) + 0.5)) ^ 2);
    end
    fit = total_sum;
end

