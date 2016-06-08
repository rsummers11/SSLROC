function [Para] = set_para(dataset, P1, P2)

% dataset
Para.Global.dataset = dataset; %for cases

% ratio between false and true bags
% Para.Global.ratio_F2T = 1;% b

% total number of samples to be kept after downsampling
Para.Global.N = 100;% 

% sigma value for Gaussian kernel on selected training set (select_training_bags2)
Para.Global.sigma = 0.05;% 

% number of features to be selected
Para.Global.K_FS = 5;% 

Para.Global.solver = 'sedumi';% sedumi, sdpt3
% Para.Global.solver = 'sdpt3';% sdpt3 for norm1 SSL1
Para.Global.sedumi.eps = 1e-4;

Para.Global.C = 10^P1;% 1e-3, 1e-2, 1e-1 1e0, 1e1 1e2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Para.Global.ratio_ieta = ratio_ieta; %V
Para.Global.kernel_type = 'rbf';

% Para.Global.feature.perc_sigma = perc_sigma*10/100;% percentile for estimate_sigma 
Para.Global.feature.perc_sigma = 9*10/100;% percentile for estimate_sigma 
Para.Global.feature.normalization = 'ZScore';%my_normalization, ZScore

% save prediction results for each test fold; It is for roc analysis
Para.Global.flag_save_pred = 0;

% SVM
Para.SVM.kernel.flag_precomputed = true;
Para.SVM.kernel.type = Para.Global.kernel_type;%laplacian_rbf,non_gaussian_rbf,polynomial_kernel
Para.SVM.kernel.para1 = 0.01;% sigma 1/size(X1, 2); norm 0.1; zscore 0.001
Para.SVM.kernel.para2 = 0.5;% a
Para.SVM.kernel.para3 = 1;% b
% Para.SVM.ratio_F2T = Para.Global.ratio_F2T;% b
Para.SVM.C = Para.Global.C;% 0.6

% SDP
Para.SDP.C = Para.Global.C;% 0.6
Para.SDP.kernel.flag_precomputed = true;
Para.SDP.kernel.type = Para.Global.kernel_type;%laplacian_rbf,non_gaussian_rbf,polynomial_kernel,linear
Para.SDP.kernel.para1 = 0.01;% sigma 1/size(X1, 2)
% Para.SDP.ratio_F2T = Para.Global.ratio_F2T;% b
Para.SDP.flag_MI = 1;
Para.SDP.flag_norm = 2;
% Para.SDP.ratio_ieta = Para.Global.ratio_ieta;
Para.SDP.solver = Para.Global.solver;% sdpt3, sedumi
Para.SDP.sedumi.eps = Para.Global.sedumi.eps;
Para.SDP.sdpt3.maxit = 100;
Para.SDP.sdpt3.gaptol = 1e-5;

% SVM ROC
Para.SVMROC.C = Para.Global.C;
Para.SVMROC.kppv = inf;
Para.SVMROC.margin = 0.01;
Para.SVMROC.lambda = 1e-7;
Para.SVMROC.kernel = 'gaussian';
Para.SVMROC.kerneloption = 1;
Para.SVMROC.verbose = 1;
Para.SVMROC.span = 1;
Para.SVMROC.qpsize = 1000;

% Rank Boost
Para.RankBoost.T = P1;
% Para.RankBoost.C = Para.Global.C;

% OPAUC
Para.OPAUC.eta = 2^P1;
Para.OPAUC.lambda = 2^P2;

% SVMlin
Para.SVMlin.fn_training_label = 'SVMlin_training_label';
Para.SVMlin.fn_training_data = 'SVMlin_training_data';
Para.SVMlin.fn_test_label = 'SVMlin_test_label';
Para.SVMlin.fn_test_data = 'SVMlin_test_data';
Para.SVMlin.fn_prediction = 'pred_ssrankboost.txt';
Para.SVMlin.lambda = 10^P1;
Para.SVMlin.lambda_u = 10^P2;

% MySSRankBoost
Para.SSRankBoost.fn_training = 'SSRankBoost_training';
Para.SSRankBoost.fn_test = 'SSRankBoost_test';
Para.SSRankBoost.fn_model = 'model_SSRankBoost';
Para.SSRankBoost.fn_prediction = 'pred_ssrankboost.txt';
Para.SSRankBoost.discount_factor = P1;
Para.SSRankBoost.k = P2;


% SSL
Para.SSL.C1 = 10^P1;
% Para.SSL.C2 = 10^P2;
Para.SSL.C2 = Para.SSL.C1;
Para.SSL.kernel.flag_precomputed = true;
Para.SSL.kernel.type = Para.Global.kernel_type;%laplacian_rbf,non_gaussian_rbf,polynomial_kernel,linear
Para.SSL.kernel.para1 = 0.01;% sigma 1/size(X1, 2)
Para.SSL.M = 10^P2;% 1
Para.SSL.flag_norm = 2;
Para.SSL.sedumi.eps = Para.Global.sedumi.eps;
Para.SSL.sdpt3.maxit = 100;% 100 for 2012/09/12
Para.SSL.sdpt3.gaptol = 1e-8;% 1e-4 for uci; 1e-8 for mturk
Para.SSL.solver = Para.Global.solver;% sdpt3, sedumi
Para.SSL.SDP_reduction = false;
Para.SSL.reduction.K = 20; % number of neibors in SDP reduction
Para.SSL.reduction.flag_training = false;
Para.SSL.l1_loss.flag_regu = false;% true for uci; false for mturk
Para.SSL.l1_loss.regu = 1;% 1 for uci; 0.1 for mturk
Para.SSL.l1_loss.flag_fixed = true;% whether use fixed regulizer for different C


Para.evaluation.num_randomization = 5; %1
Para.evaluation.CV.num_folds = 2;

 