function y = step(x)
    D = length(x);
    sum = 0;
    for i = 1:D
        sum = sum + ((floor(x(i) + 0.5)) ^ 2);
    end
    y = sum;
end

% bounds [-100, 100]
% maximum evaluations 150,000
% optimal 0.0


