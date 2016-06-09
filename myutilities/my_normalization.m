% Normalize each feature to [0, 1]
function [X1_normalized, X2_normalized] = my_normalization(X1, X2)

if nargin>1

    [N1 M1] = size(X1);
    [N2 M2] = size(X2);
    
    if M1 ~= M2
        fprintf('Warning: the two matrices to be normalized have different dimensions!\n');
    end
        

    X1_normalized = zeros(N1, M1);
    X2_normalized = zeros(N2, M2);

    for i=1: M1
        min_value1 = min(X1(:, i));
        min_value2 = min(X2(:, i));
        min_value = min(min_value1, min_value2);

        max_value1 = max(X1(:, i));
        max_value2 = max(X2(:, i));
        max_value = max(max_value1, max_value2);

        if abs(max_value - min_value) > 1e-10
            X1_normalized(:, i) = ( X1(:, i) - ones(N1, 1)*min_value ) / (max_value - min_value);
            X2_normalized(:, i) = ( X2(:, i) - ones(N2, 1)*min_value ) / (max_value - min_value);
        end
    end  

else
    [N1 M1] = size(X1);

    X1_normalized = zeros(N1, M1);

    for i=1: M1
        min_value1 = min(X1(:, i));
        max_value1 = max(X1(:, i));

        if abs(max_value1 - min_value1) > 1e-10
            X1_normalized(:, i) = ( X1(:, i) - ones(N1, 1)*min_value1 ) / (max_value1 - min_value1);
        end
    end  
end