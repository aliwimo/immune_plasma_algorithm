function y = rosenbrock(x)
    D = length(x);
    sum = 0;
    for i = 1:(D - 1)
        x_i = x(i);
        x_next = x(i + 1);
        sum = sum + 100 * (x_next - x_i^2)^2 + (x_i - 1)^2;
    end
    y = sum;
end

% bounds [-30, 30]
% maximum evaluations 500,000
% optimal 0
