function [tpr, fpr] = MyFROC(Y, decision_values, thresholds)

N = length(Y);
num_steps = length(thresholds);

tpr = zeros(num_steps, 1);
fpr = zeros(num_steps, 1);

decision_values = my_normalization(decision_values); 

num_true = 0;
for i=1: N
    if Y(i) > 0;
        num_true = num_true + 1;
    end
end

for j=1: num_steps
    SVM_threshold = thresholds(j);

    error_FP = 0;
    error_TP = 0;

    for i=1: N
        % false positive
        if decision_values(i, 1) >= SVM_threshold
            if Y(i) <= 0
                error_FP = error_FP + 1;
            end
        end
        % miss true
        if decision_values(i, 1) < SVM_threshold
            if Y(i) > 0
                error_TP = error_TP + 1;
            end
        end    
    end

    tpr(j) = 1 - error_TP / num_true;
    fpr(j) = error_FP / (N - num_true);    
end

tpr(1) = 1;
tpr(num_steps) = 0;
fpr(1) = 1;
fpr(num_steps) = 0;