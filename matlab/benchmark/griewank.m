function fit = griewank(x)
    dimension_size = length(x);
    total_sum = 0;
    total_prod = 1;
    for i = 1:dimension_size
        total_sum = total_sum + x(i)^2 / 4000;
        total_prod = total_prod * cos(x(i) / sqrt(i));
    end
    fit = total_sum - total_prod + 1;
end

% bounds [-600, 600]
% maximum evaluations 200,000
% optimal 0