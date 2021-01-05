function y = rastrigin(x)
    D = length(x);
    sum = 0;
    for i = 1:D
        sum = sum + ( x(i)^2 - (10 * cos(2 * pi * x(i))) + 10 );
    end
    y = sum;
end

% bounds [-5.12, 5.12]
% maximum evaluations 300,000
% optimal 0