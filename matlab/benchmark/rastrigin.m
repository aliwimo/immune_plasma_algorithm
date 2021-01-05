function fit = rastrigin(x)
    dimension_size = length(x);
    total_sum = 0;
    for i = 1:dimension_size
        total_sum = total_sum + ( x(i)^2 - (10 * cos(2 * pi * x(i))) + 10 );
    end
    fit = total_sum;
end

% bounds [-5.12, 5.12]
% maximum evaluations 300,000
% optimal 0