function [energy] = my_energy(W)

[d1, d2, d3] = size(W);
tt_vec(:, 1) = W(:);

tt_vec = tt_vec .^ 2;

energy = sum(tt_vec) / (d1*d2*d3);

% function [energy] = my_energy(tt_vec, tt_size)
% 
% tt_vec = tt_vec .^ 2;
% 
% energy = sum(tt_vec) / (tt_size(1)*tt_size(2)*tt_size(3));