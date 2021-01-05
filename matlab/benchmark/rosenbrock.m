function fit = rosenbrock(x)
    d = length(x);
    sum = 0;
    for i = 1:(d-1)
        x_i = x(i);
        x_next = x(i + 1);
        sum = sum + 100*(x_next - x_i^2)^2 + (x_i - 1)^2;
    end
    fit = sum;
end

% bounds [-30, 30]
% maximum evaluations 500,000
% optimal 0

% function fit = rosenbrock(x)
%     dimension_size = length(x);
%     total_sum = 0;
%     for i = 1:(dimension_size - 1)
%         total_sum = total_sum +   100 * ( x(i + 1) - x(i)^2 )^2  + (( x(i) - 1 )^2) ;
%     end
%     fit = total_sum;
% end


