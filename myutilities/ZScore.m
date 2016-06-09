function [X_new] = ZScore(X)

X_mean = mean(X);
X_std = std(X);

[N, M] = size(X);

% avoid features with 0 std
for i=1: M
    if X_std(i) < 1e-10
        X_mean(i) = 0;
        X_std(i) = 1;
    end
end


X_new = (X - repmat(X_mean, N, 1)) * diag(1 ./ X_std);
