function [ypred] = MyRankBoost(yapp, xapp, x_test, para)

% % tuning parameter T based on C which is tested by other methods
% pool_C = [0.000001 0.00001 0.0001 0.001 0.01 0.1 1 10 100];
% pool_T = [10 20 30 40 50 60 70 80 90];
% 
% ind = find(pool_C==para.C, 1);
% T = pool_T(ind);
% % T = 30;

T = para.T

%  USAGE
%
% [alpha,threshold,rankfeat]=rankboostAUC(xapp,yapp,T);
%
%  This a Rankboost algorithm as described in the freund et al
%  Journal of Machine Learning Research paper.
%  
%  xapp and yapp are the learning set data and labels
%  T is the number of weak learners which is a step function.
%
%  the outputs are 
%  
%   alpha  : vector  of weight of each weak learner
%   threshold : vector of each weak learner translation
%   rankfeat : vector of each weak learner feature.
[alpha, threshold, rankfeat] = rankboostAUC(xapp,yapp,T);

% USAGE
%
% ypred=rankboostAUCval(x,alpha,threshold,rankfeat,T);
%
% evaluate a rankboost decision function of data x
%
%  the inputs are 
%  
%   alpha  : vector  of weigth of each weak learner
%   threshold : vector of each weak learner translation
%   rankfeat : vector of each weak learner feature.
%   T       : number of weak learners
ypred = rankboostAUCval(x_test, alpha, threshold, rankfeat, T);