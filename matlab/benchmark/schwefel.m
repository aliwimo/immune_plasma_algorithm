function y = schwefel(x)    
    D = length(x);
    sum = 0;
    for i = 1:D
        xi = x(i);
        sum = sum + (xi * sin(sqrt(abs((xi / pi) * 180))));
    end
    y = - sum;
end

% bounds [-500, 500]
% maximum evaluations 300,000
% optimal -D * 418.98