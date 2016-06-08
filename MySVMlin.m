% M.-R. Amini, V. Truong, C. Goutte. A Boosting Algorithm for Learning Bipartite Ranking Functions with Partially Labeled Data. 
% Proceedings of the 31st International ACM SIGIR (SIGIR 2008), 2008. 
% http://vikas.sindhwani.org/svmlin.html
function [pred] = MySVMlin(Y1, X1, Y2, X2, para)

lambda = para.lambda;
lambda_u = para.lambda_u;

% create training and test files
fn_training_label = para.fn_training_label;
fn_training_data = para.fn_training_data;
fn_test_label = para.fn_test_label;
fn_test_data = para.fn_test_data;

% % parameter_file for trained model
% fn_model = para.fn_model;
% fn_prediction = para.fn_prediction;

% put all test cases in the training set for SSL
% labels of test cases are zero (not +1 or -1 like training cases)
Y_training = [Y1; zeros(length(Y2), 1)];

svmlin_input(Y_training, [X1; X2], fn_training_label, fn_training_data);
svmlin_input(Y2, X2, fn_test_label, fn_test_data);


% Usage
%      Train: svmlin [options] training_examples training_labels
%       Test: svmlin -f weights_file test_examples
%   Evaluate: svmlin -f weights_file test_examples test_labels
% 
%  Options:
%  -A  algorithm : set algorithm (default 1) 
%          0 -- Regularized Least Squares (RLS) Classification
%          1 -- SVM (L2-SVM-MFN) (default choice)
%          2 -- Multi-switch Transductive SVM (using L2-SVM-MFN)
%          3 -- Deterministic Annealing Semi-supervised SVM (using L2-SVM-MFN)
%  -W  regularization parameter lambda   (default 1) 
%  -U  regularization parameter lambda_u (default 1) (
%           lambda_u is a user-provided parameter that provides control over the influence of unlabeled data
%  -S  maximum number of switches in TSVM (default 0.5*number of unlabeled examples)
%  -R  positive class fraction of unlabeled data  (0.5)
%  -f  weights_filename (Test Mode: input_filename is the test file)
%  -Cp relative cost for positive examples (only available with -A 1)
%  -Cn relative cost for negative examples (only available with -A 1)
% MFN: Modified Finite Newton
command_train = sprintf('svmlin-v1.0/svmlin -A 3 -W %f -U %f %s %s', lambda, lambda_u, fn_training_data, fn_training_label);
system(command_train);

command_test = sprintf('svmlin-v1.0/svmlin -f %s.weights %s %s', fn_training_data, fn_test_data, fn_test_label);
system(command_test);

pred = load([fn_test_data '.outputs']);
