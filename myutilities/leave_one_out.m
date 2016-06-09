% leave one patient out test
function [tp, fp, Y, decision_values] = leave_one_out(Y, X, id_patient, para)

% SVM_gamma = para.SVM_gamma;
% num_feature_selected = para.num_feature_selected;

num_patient = length(unique(id_patient));

N = length(Y);
testSetLabel = zeros(N, 1);
decision_values = zeros(N, 1);
count = 0;

for i=1: num_patient
    fprintf('No. patient: %d\n', i);

    [Y_train, X_train, Y_test, X_test] = select_loo_samples(Y, X, id_patient, i); 

    % select training set for balance
    num_true_samples = sum(Y_train == 1);
    num_false_samples = sum(Y_train == -1);
    num_each_class = min(num_true_samples, num_false_samples);
    % warning: negative samples may be less than positive samples + solved
    [Y_train_balanced, X_train_balanced] = select_training_samples(Y_train, X_train, [num_each_class num_each_class]);
    
%     % feature selection
%     [feature_selected] = my_fs(Y_train_balanced, X_train_balanced, num_feature_selected);
%     X_train = X_train(:, feature_selected);
% 	X_train_balanced = X_train_balanced(:, feature_selected);
% 	X_test = X_test(:, feature_selected);

    if size(Y_test, 1) > 0
        
        disp('Start training and test of SVM ...');
        %[yt, dt] = MySVM3(Y_train_balanced, X_train_balanced, Y_test, X_test, SVM_gamma);
        % Para.kernel.para1 =SVM_gamma;% sigma
        % Para.kernel.flag_precomputed = false;        
        [tp, fp, dv] = MySVM(Y_train_balanced, X_train_balanced, Y_test, X_test, para.kernel);

        for j=1: size(Y_test, 1)
            count = count + 1;
            testSetLabel(count) = Y_test(j);
            decision_values(count) = dv(j);
        end
    end
end

[tp, fp] = roc(testSetLabel, decision_values);