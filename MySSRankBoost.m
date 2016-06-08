% M.-R. Amini, V. Truong, C. Goutte. A Boosting Algorithm for Learning Bipartite Ranking Functions with Partially Labeled Data. 
% Proceedings of the 31st International ACM SIGIR (SIGIR 2008), 2008. 
% http://ama.liglab.fr/~amini/SSRankBoost/
function [pred] = MySSRankBoost(Y1, X1, Y2, X2, para)

discount_factor = para.discount_factor;
k = para.k;

% create training and test files
fn_training = para.fn_training;
fn_test = para.fn_test;
% parameter_file for trained model
fn_model = para.fn_model;
fn_prediction = para.fn_prediction;

% put all test cases in the training set for SSL
% labels of test cases are zero (not +1 or -1 like training cases)
Y_training = [Y1; zeros(length(Y2), 1)];

libsvm_input(Y_training, [X1; X2], fn_training);
libsvm_input(Y2, X2, fn_test);

% train 
% Options are:
% -l    (float) 	The discount factor regularizing the impact of the objective term over unlabeled examples in the learning process. If -l is not specified, the program corresponds to the supervised RankBoost algorithm for bipartite ranking [Freund et al. 2003],
% -k   (integer) 	The number of unlabeled examples which are given the same relevance judgment than their most nearest labeled neighbor (default 3),
% -n   (integer) 	The number of candidate thresholds over features - stumps (default 10),
% -t   (integer) 	The number of boosting iterations (default 50),
% -? 	Help
command_train = sprintf('semisup_rankboost/ssrankboost-learn -l %f -k %d %s %s', discount_factor, k, fn_training, fn_model);
system(command_train);

command_test = sprintf('semisup_rankboost/ssrankboost-test %s %s', fn_test, fn_model);
system(command_test);

temp = load(fn_prediction);
pred = temp(:, 1);