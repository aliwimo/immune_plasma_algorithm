function y = quartic(x)
    D = length(x);
    total_sum = 0;
    for i = 1:D
        total_sum = total_sum +  i * (x(i)^4);
    end
    y = total_sum + rand;
end

% bounds [-1.28, 1.28]
% maximum evaluations 300,000
% optimal 0.0
