% Standard SVM
% function [sensitivity, false_alarm_probability] = MySVM(Y, X, flagLabeled, SVM_gamma, thresholds, num_patients_test)
function [tp, fp, K_train, K_test, decision_values] = MySVM2(Y1, X1, Y2, X2, para)

para_kernel = para.kernel;
% ratio_F2T = para.ratio_F2T;
C = para.C;
% C = 1;

if nargin > 4
    % calculate kernels before SVM training
    trainSetLabel = Y1;
    trainSetData = X1;
    testSetLabel = Y2;
    testSetData = X2;

    K_train = [];
    K_test = [];

    % train and test SVM
    if para_kernel.flag_precomputed
        % use precomputed kernel 
        K_train = calculate_kernel(trainSetData, [], para_kernel);
        K_train2 = [(1:size(K_train, 1))', K_train];

        %model = svmtrain(trainSetLabel, K_train2, '-t 4 -c 1');
        % strcat will remove trailing spaces
		% line_command = strcat('-t 4 -c 1 -w1 ', num2str(ratio_F2T), ' -w-1 1');%
        % line_command = ['-t 4 -c ', num2str(C), ' -w1 ', num2str(ratio_F2T), ' -w-1 1'];
        line_command = ['-t 4 -c ', num2str(C), ' -w1 ', num2str(sum(trainSetLabel<=0)/sum(trainSetLabel>0)), ' -w-1 1'];
		model = svmtrain(trainSetLabel, K_train2, line_command);

        K_test = calculate_kernel(testSetData, trainSetData, para_kernel);
        K_test2 = [(1:size(K_test, 1))', K_test];
        [predict_label, accuracy, decision_values] = svmpredict(testSetLabel, K_test2, model);    
    else
        SVM_gamma = para_kernel.para1;
        para = ['-s 0 -c 1 -t 2 -g ', num2str(SVM_gamma)];
        model = svmtrain(trainSetLabel, trainSetData, [para]);
        [predicted_label, accuracy, decision_values] = svmpredict(testSetLabel, testSetData, model, ['']);    
    end
else
    % use precomputed kernel
    K_train2 = [(1:size(X1, 1))', X1];
    K_test2 = [(1:size(X2, 1))', X2];
    model = svmtrain(Y1, K_train2, '-t 4 -c 1');
    [predict_label, accuracy, decision_values] = svmpredict(Y2, K_test2, model); 
    %decision_values = my_normalization(decision_values);    
    
    testSetLabel = Y2;    
    K_train = X1;
    K_test = X2;
end

[tp, fp] = roc(testSetLabel, decision_values);


% Usage: svm-train [options] training_set_file [model_file]
% options:
% -s svm_type : set type of SVM (default 0)
% 	0 -- C-SVC
% 	1 -- nu-SVC
% 	2 -- one-class SVM
% 	3 -- epsilon-SVR
% 	4 -- nu-SVR
% -t kernel_type : set type of kernel function (default 2)
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% 	4 -- precomputed kernel (kernel values in training_set_file)
% -d degree : set degree in kernel function (default 3)
% -g gamma : set gamma in kernel function (default 1/k)
% -r coef0 : set coef0 in kernel function (default 0)
% -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
% -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
% -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
% -m cachesize : set cache memory size in MB (default 100)
% -e epsilon : set tolerance of termination criterion (default 0.001)
% -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
% -b probability_estimates: whether to train an SVC or SVR model for probability estimates, 0 or 1 (default 0)
% -wi weight: set the parameter C of class i to weight*C in C-SVC (default 1)
% -v n: n-fold cross validation mode



% if length(Y2) == 0
%     [N M] = size(X1);
% 
%     countTrainSamples = 0;
%     countTestSamples = 0;
% 
%     % count the numbers of training samples or test samples
%     numTraining = 0;
%     for i=1: N
%         if flagLabeled(i)
%             numTraining = numTraining + 1;
%         end
%     end
%     numTesting = N - numTraining;
% 
%     % preallocating for training set and test set
%     trainSetLabel = zeros(numTraining, 1);
%     trainSetData = zeros(numTraining, M);
%     testSetLabel = zeros(numTesting, 1);
%     testSetData = zeros(numTesting, M);
% 
%     % generate training set and testing set
%     for i=1: N
%         if flagLabeled(i) && Y1(i) > 0
%             countTrainSamples = countTrainSamples + 1;
%             trainSetLabel(countTrainSamples) = Y1(i);
%             trainSetData(countTrainSamples, :) = X1(i, :);
%         end   
%     end
%     for i=1: N
%         if flagLabeled(i) && Y1(i) < 0
%             countTrainSamples = countTrainSamples + 1;
%             trainSetLabel(countTrainSamples) = Y1(i);
%             trainSetData(countTrainSamples, :) = X1(i, :);
%         elseif ~flagLabeled(i)
%             countTestSamples = countTestSamples + 1;
%             testSetLabel(countTestSamples) = Y1(i);
%             testSetData(countTestSamples, :) = X1(i, :);        
%         end   
%     end
% else
%     trainSetLabel = Y1;
%     trainSetData = X1;
%     testSetLabel = Y2;
%     testSetData = X2;
% end