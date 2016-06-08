% clear;
% clc;
% MyGlobal;

function experiment(method, dataset, P1, P2)

clock_start = clock;

MyGlobal;

global path_data;
% global path_result;

if ischar(method)
    method = str2num(method);
end

if ischar(dataset)
    dataset = str2num(dataset);
end
if ischar(P1)
    P1 = str2num(P1);
end
if exist('P2', 'var') 
    if ischar(P2)
        P2 = str2num(P2);
    end
end

if exist('P2', 'var')
    fprintf('\n+++++++++++++++method=%d, dataset=%d, P1=%f, P2=%f\n', method, dataset, P1, P2);
else
    fprintf('\n+++++++++++++++method=%d, dataset=%d, P1=%f\n', method, dataset, P1);
end

if ~exist('P2', 'var') 
    P2 = 0;
end

switch method
    case 1
        name_method='SVM';
    case 2
        name_method='SVMROC';
    case 3
        name_method='RankBoost';
    case 4
        name_method='OPAUC';
    case 5
        name_method='SVMlin';
    case 6
        name_method='SSRankBoost';        
    case 7
        name_method='SSL1';% norm 1 SSLROC
    case 8
        name_method='SSL2';% norm 2 SSLROC
    otherwise
        warning('Undefined method!')
end

% random generator seed
% rng('default') puts the settings of the random number generator used by rand, randi, and randn to 
% their default values so that they produce the same random numbers as if you restarted MATLAB. In this release (2013b), 
% the default settings are the Mersenne Twister with seed 0
rng('default')

% MTurk uses different seed
if dataset == 104
    rng(20140622)
end

Para = set_para(dataset, P1, P2);

flag_save_pred = Para.Global.flag_save_pred;

fprintf('\nNormalization method for features: %s\n', Para.Global.feature.normalization);
fprintf('Percentile of estimate_sigma: %f\n', Para.Global.feature.perc_sigma);

% load data
[Y_ori, X_ori, Para.Global.name, anon_ori] = load_data(path_data, Para.Global);
fprintf('Number of instances in the dataset: %d\n', length(Y_ori));
name_dataset = Para.Global.name;


% re-arrange pos/neg samples
% loaed Y_ori and X_ori were sorted/ranked based on SVM committee
% classifier predictions
% + is it necessary: only for MTurk dataset
if dataset==104
    no_fp = Y_ori<0;
    no_tp = Y_ori>0;
    Y = [Y_ori(no_tp,:); Y_ori(no_fp(1:100),:)];
    X = [X_ori(no_tp,:); X_ori(no_fp(1:100),:)];
    Y_ori = Y;
    X_ori = X;

    anon = [anon_ori(no_tp,:); anon_ori(no_fp,:)];
    anon_ori = anon;
end

% pre-allocation of AUC results
total_num_folds = Para.evaluation.num_randomization * Para.evaluation.CV.num_folds;
AUC_folds = zeros(total_num_folds,1);

% down sampling
N = min(Para.Global.N, length(Y_ori)); %switch


if exist('N.mat', 'file')
    load N.mat;
    
    if N > length(Y_ori)
        N = length(Y_ori);
    end
end

fprintf('Number of total samples in training and test sets: %d.\n', N);

% generate randomization numbers first
rn = zeros(Para.evaluation.num_randomization, length(Y_ori));
for i=1: Para.evaluation.num_randomization
    rn(i, :) = randperm(length(Y_ori));
end
rn(:, 1:5)

count = 0;
% for r = 1:1:Para.evaluation.num_randomization %5
no_rand = 0; % controls randomization
while no_rand<Para.evaluation.num_randomization
    no_rand = no_rand + 1;

    % randomize the original dataset
    idx = rn(no_rand, 1:N);
    Y = Y_ori(idx, :);
    X = X_ori(idx, :);
    anon = anon_ori(idx, :);
 
    if length(unique(Y)) ~= 2
        fprintf('Error: the dataset contains only one class!\n');
        exit(1);
    end

    % K-fold cross validation
    for t=1: Para.evaluation.CV.num_folds %2
        count = count + 1;
        fprintf('\nRandomization %d, fold %d, count %d, ...\n', no_rand, t, count);
        [Y_training, X_training, Y_test, X_test, anon_test] = MyCrossValid(Y, X, Para.evaluation.CV, t, anon);
        anon_test_all{count} = anon_test;

        % balance true and false training samples
%         min_num_class = min(sum(Y_training>0), sum(Y_training<0));
%         [YB_training, XB_training] = select_training_samples(Y_training, X_training, [min_num_class min_num_class]);
        YB_training = Y_training;
        XB_training = X_training;

        % skip this for OPAUC, rankboost and svmlin
        if 1
            Para.Global.sigma = estimate_sigma(double([XB_training; X_test]), Para.Global.feature.perc_sigma);
            fprintf('\n Para.Global.sigma: %f\n', Para.Global.sigma);
            Para.SVM.kernel.para1 = Para.Global.sigma;
            Para.SDP.kernel.para1 = Para.Global.sigma;
            Para.ml.kernel.para1 = Para.Global.sigma;
            Para.SSL.kernel.para1 = Para.Global.sigma;
            Para.SVMROC.kerneloption = (1/(2*Para.Global.sigma))^0.5;
        end
            
        switch method
            case 1 % SVM
                disp('Start training and testing of a single SVM with all features...');

                % Para.SVM.kernel.para1 = Para.Global.sigma;
                fprintf('Para.SVM.C = %f\n', Para.SVM.C);
                [tp_SVM, fp_SVM, K_train, K_test_SVM, dv_SVM{t}] = MySVM2(YB_training, XB_training, Y_test, X_test, Para.SVM);
                if flag_save_pred
                    save_result([Para.Global.name '_' 'SVM' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_SVM{t});
                end
                [tp, fp] = roc(Y_test, dv_SVM{t});


            case 2 % SVMROC
                fprintf('Para.SVMROC.C = %f\n', Para.SVMROC.C);
                [dv_SVMROC{t}] = MySVMROC(YB_training, XB_training, X_test, Para.SVMROC);

                [tp, fp] = roc(Y_test, dv_SVMROC{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'SVMROC' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_SVMROC{t});
                end

         
            case 3 % RankBoost
                fprintf('Para.RankBoost.T = %d\n', Para.RankBoost.T);
                [dv_RankBoost{t}] = MyRankBoost(YB_training, XB_training, X_test, Para.RankBoost);

                [tp, fp] = roc(Y_test, dv_RankBoost{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'RankBoost' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_RankBoost{t});
                end

         
            case 4 % OPAUC
                fprintf('Para.OPAUC.eta = %f\n', Para.OPAUC.eta);
                fprintf('Para.OPAUC.lambda = %f\n', Para.OPAUC.lambda);
                [dv_OPAUC{t}] = MyOPAUC(YB_training, XB_training, X_test, Para.OPAUC);

                [tp, fp] = roc(Y_test, dv_OPAUC{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'OPAUC' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_OPAUC{t});
                end

    
            case 5 % SVMlin
                % Para.SVMlin.lambda = P1;
                fprintf('Para.SVMlin.eta = %f\n', Para.SVMlin.lambda);
                fprintf('Para.SVMlin.lambda = %f\n', Para.SVMlin.lambda_u);

                [dv_SVMlin{t}] = MySVMlin(YB_training, XB_training, Y_test, X_test, Para.SVMlin);

                [tp, fp] = roc(Y_test, dv_SVMlin{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'SVMlin' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_SVMlin{t});
                end

         
            case 6 % SSRankBoost
                % Para.SSRankBoost.discount_factor = P1;
                fprintf('Para.SSRankBoost.discount_factor = %f\n', Para.SSRankBoost.discount_factor);
                fprintf('Para.SSRankBoost.k = %f\n', Para.SSRankBoost.k);

                [dv_SSRankBoost{t}] = MySSRankBoost(YB_training, XB_training, Y_test, X_test, Para.SSRankBoost);

                [tp, fp] = roc(Y_test, dv_SSRankBoost{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'SSRankBoost' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_SSRankBoost{t});
                end

                
            case {7, 8} % SSL
                if method == 7
                    Para.SSL.flag_norm = 1;
                    Para.SSL.solver = 'sdpt3';
                else
                    Para.SSL.flag_norm = 2;
                    Para.SSL.solver = 'sedumi';
                end

                fprintf('Para.SSL.flag_norm=%d\n', Para.SSL.flag_norm);
                fprintf('Para.SSL.C1 = %f\n', Para.SSL.C1);
                fprintf('Para.SSL.C2 = %f\n', Para.SSL.C2);
                fprintf('Para.SSL.M = %f\n', Para.SSL.M);
                
                [dv_SSL{t}, output_SSL] = ROC_SSL(YB_training, XB_training, X_test, Para.SSL); %%%

                [tp, fp] = roc(Y_test, dv_SSL{t});

                if flag_save_pred
                    save_result([Para.Global.name '_' 'SSL' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, dv_SSL{t});
                    save_result([Para.Global.name '_' 'anon' '_C' num2str(P1) '_P' num2str(P2)], count, Y_test, anon_test);
                end

            otherwise
                fprintf('Unknown method!\n');
                exit(0);
        end
        
        AUC_folds(count) = auroc(tp, fp);
        if AUC_folds(count) < 0.5
            AUC_folds(count) = 1 - AUC_folds(count);
        end
    end %for end
end %for end

% save AUC
str1 = num2str(P1);
str2 = num2str(P2);
save_result([name_method '/' Para.Global.name '_AUC_' name_method '_P1_' str1 '_P2_' str2], [1:10]', AUC_folds);  

timespan = etime(clock, clock_start);
fprintf('End of experiment. Time used: %f seconds.\n', timespan);
% exit(0);
