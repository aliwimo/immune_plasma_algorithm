function y = griewank(x)
    D = length(x);
    sum = 0;
    prod = 1;
    for i = 1:D
        sum = sum + x(i)^2 / 4000;
        prod = prod * cos(x(i) / sqrt(i));
    end
    y = sum - prod + 1;
end

% bounds [-600, 600]
% maximum evaluations 200,000
% optimal 0