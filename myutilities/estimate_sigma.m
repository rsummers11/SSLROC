
% estimate sigma for rbf kernel
% X: input samples
% p: percentile of pairwise distances
function [sigma] = estimate_sigma(X, p)

if exist('p', 'var')
    percentile = p;
else
    percentile = 0.5;% 0.1, 0.5 (median), 0.9 , 0.001 for multi-kernel learning
end

[N] = size(X, 1);

% D = pdist(X);

% ? use tril()
EuD = EuDist2(X);
% D = reshape(D, [], 1);

D = [];

for i=1: N-1
    D = [D; EuD(i+1:N, i)];
end

% count = 0;
% for i=1: N
%     %i
%     for j=i+1: N;
%         count = count + 1;
%         dist(count, 1) = EuDist2(X(i,:), X(j,:));
%     end
% end

[B, IX] = sort(D, 'ascend');

% sigma = 1/(B(round(percentile*length(D)))^2);% old sigma
sigma = 1/(2*B(round(percentile*length(D)))^2);
