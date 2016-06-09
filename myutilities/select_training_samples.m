% bug: labels is not consistent with num_training regarding to the class
% order.
% warning: negative samples may be less than positive samples.
function [Y_train, X_train, Y_test, X_test, flagTraining] = select_training_samples(Y, X, num_training, ratio)

if length(unique(Y)) == 1
    error('Error (select_training_samples): there is only one class in the data!');
end

[N, M] = size(X);
labels = unique(Y);
num_classes = length(labels);

% sample samples without replacement
flagTraining = false(N, 1);

%Initialize rand to a different state each time:
%rand('twister', sum(100*clock));

if ~isempty(num_training) && exist('ratio', 'var')
    fprintf('Warning: both num_training and ratio are given! Follow which?');
    return;
end
if isempty(num_training) && ~exist('ratio', 'var')
    fprintf('Warning: num_training and ratio are not given!');
    return;
end

% select samples according to designated number for each class
if ~isempty(num_training) && ~exist('ratio', 'var')
    for i=1: num_classes
        count = 0;
        while count < num_training(i)
            no = ceil(rand * N);
            if no <= 0
                no = 1;
            end
            if no > N
                no = N;
            end

            if Y(no)==labels(i) && ~flagTraining(no)
                count = count + 1;
                flagTraining(no) = true;
            end
        end
    end
end

% select ratio% samples from each class as training samples
if isempty(num_training) && exist('ratio', 'var')
    % count number of samples for each class
    num_each_class = zeros(num_classes, 1);
    for i=1: num_classes
        num_each_class(i) = sum(Y == labels(i));
    end
    
    for i=1: num_classes
        num_sampled = floor(num_each_class(i) * ratio);
        if num_sampled == 0
            num_sampled = 1;
        end
        count = 0;
        while count < num_sampled
            no = ceil(rand * N);
            if no <= 0
                no = 1;
            end
            if no > N
                no = N;
            end

            if Y(no)==labels(i) && ~flagTraining(no)
                count = count + 1;
                flagTraining(no) = true;
            end
        end
    end    
end

% if it is two-class problem, we will sort the training set based on sample
% lables
if ~length(unique(Y)) == 2
    Y_train = Y(flagTraining, :);
    Y_test = Y(~flagTraining, :);
    X_train = X(flagTraining, :);
    X_test = X(~flagTraining, :);
else
    Y_train_tmp = Y(flagTraining, :);
    Y_test = Y(~flagTraining, :);
    X_train_tmp = X(flagTraining, :);
    X_test = X(~flagTraining, :);
    % re-sort the training set
    X_train = [X_train_tmp(Y_train_tmp==1, :); X_train_tmp(Y_train_tmp==-1, :)];
    Y_train = [Y_train_tmp(Y_train_tmp==1, :); Y_train_tmp(Y_train_tmp==-1, :)];
end
