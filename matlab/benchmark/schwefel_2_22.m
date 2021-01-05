function fit = schwefel_2_22(x)
    dimension_size = length(x);
    total_sum = 0;
    total_mul = 1;
    for i = 1:dimension_size
        total_sum = total_sum + abs(x(i));
        total_mul = total_mul * abs(x(i));
    end
    fit = total_sum + total_mul;
end

% bounds [-10, 10]
% maximum evaluations 200,000
% optimal 0.0
