function [entropy] = my_entropy(W)

epsilon = 0;

[d1, d2, d3] = size(W);
tt_vec(:, 1) = W(:);

tt_vec = tt_vec .^ 2;
tt_vec = tt_vec / sum(tt_vec) + epsilon;

% entropy = -1 * sum(tt_vec' * log(tt_vec)) / (d1*d2*d3);
entropy = -1 * sum(tt_vec' * log2(tt_vec));