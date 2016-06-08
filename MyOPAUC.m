function [ypred] = MyOPAUC(y, x, xtest, para)

eta = para.eta;
lambda = para.lambda;

w=OPAUC(x,y,eta,lambda);

ypred = xtest* w';