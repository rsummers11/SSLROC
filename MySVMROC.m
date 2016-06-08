function [ypred] = MySVMROC(y, x, xtest, para)

C = para.C;
kppv = para. kppv;
margin = para.margin;
lambda = para.lambda;
kernel = para.kernel;
kerneloption = para.kerneloption;
verbose = para.verbose;
span = para.span;
qpsize = para.qpsize;
% [xsup,w,w0,pos,timeps,alpha,matriceind]=svmroc(x,y,C,kppv,margin,lambda,kernel,kerneloption,verbose,span,qpsize,matriceind)
%
% SVM ROC Optimizer that can handle LS problem and large neighboorhood. This
% algorithm uses a decomposition procedure.
%
%  x y          the learning data and labels
%  C            penalization parameters
%  kppv         the number of neighboor to consider. choose kppv=inf for
%               genuine ROC-SVM with no approx.
%  margin       the margin for ranking
%  lambda       conditioning parameter for the qp problem e.g 1e-7
%  kernel       the kernel type e.g 'gaussian' or 'poly'
%  kerneloption kernel parameters
%  verbose      verbosity of the algo 0 or 1
%  span         type of semi parametric function e.g 1
%  qpsize       size of qp algorithm
%
% Outputs as usual for SVM except that xsup is a cell containing
% the couple of positive and negative support vectors.
[xsup,w,w0,pos,timeps,alpha,matriceind]=svmroc(x,y,C,kppv,margin,lambda,kernel,kerneloption,verbose,span,qpsize);


% USAGE
%
% [AUC,tpr,fpr,b]=svmroccurve(xtest,ytest,xsup,w,w0,kernel,kerneloption,span)
%
%  process the ROC curve and the AUC for SVM model (either SVMROC or SVM L2) 
% 
%  the inputs are as usual for SVM
%
% if nargin == 2 then the entries are
% 
% [AUC,tpr,fpr,WMW,b]=svmroccurve(ypred,ytest);
%
%
% the outputs
%
% AUC       Area under curve value
% tpr,fpr   true positive and false positive vector for ROC curve plotting purpose
% b         a new bias for the decision function. b can replace w0 and it has been
%           processed so that the decision function corresponds to the one where the roc
%            curve and the (1,0)-(0,1) diagonal meets
%
ypred = svmrocval(xtest,xsup,w,w0,kernel,kerneloption,span);