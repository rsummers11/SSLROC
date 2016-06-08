% divide training set into true/false groups
function [XB_training_true, XB_training_false] = divide_TF(YB_training, XB_training)

% XB_training_true = XB_training(YB_training==+1, :);
% XB_training_false = XB_training(YB_training==-1, :);

XB_training_true = XB_training(YB_training>0, :);
XB_training_false = XB_training(YB_training<=0, :);