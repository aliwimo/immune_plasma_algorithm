function fit = schwefel_1_2(x)
    dimension_size = length(x);
    max_value = abs(x(1));
    for i = 2:dimension_size
        if max_value < abs(x(i))
            max_value = abs(x(i));
        end
    end
    fit = max_value;
end


% bounds [-100, 100]
% maximum evaluations 500,000
% optimal 0.0

% function fit = schwefel_1_2(x)
%     dimension_size = length(x);
%     total_sum = 0;
%     for i = 1:dimension_size
%         inner_sum = 0;
%         for j = 1:i
%             inner_sum = inner_sum + x(j);
%         end
%         total_sum = total_sum + inner_sum;
%     end
%     fit = total_sum;
% end


