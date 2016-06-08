% K-fold cross validation

function [Y_training, X_training, Y_test, X_test, anon_test] = MyCrossValid(Y, X, para, iter, anon)

% number of folds
num_folds = para.num_folds;
% number of samples in X and Y
N = length(Y);

% % randomize the original dataset
% idx = randperm(N);

% Y = Y(idx, :);
% X = X(idx, :);

flag_training = true(N, 1);

% num_samples_fold = floor(N/num_folds);
num_samples_fold = N/num_folds;

flag_training(floor(num_samples_fold*(iter-1)+1): floor(num_samples_fold*iter), :) = false;

Y_training = Y(flag_training, :);
X_training = X(flag_training, :);

Y_test = Y(~flag_training, :);
X_test = X(~flag_training, :);
anon_test = anon(~flag_training, :);