function y = schwefel_2_22(x)
    D = length(x);
    sum = 0;
    prod = 1;
    for i = 1:D
        absx = abs(x(i));
        sum = sum + absx;
        prod = prod * absx;
    end
    y = sum + prod;
end

% bounds [-10, 10]
% maximum evaluations 200,000
% optimal 0.0
