function [flag_removal] = reduction_KNN(X_training_P, X_training_N, X_test, para)

K = para.K;
flag_training = para.flag_training;

dist_PN = EuDist2(X_training_P, X_training_N);
dist_UN = EuDist2(X_test, X_training_N);
dist_UP = EuDist2(X_test, X_training_P);


[Np, Nn] = size(dist_PN);
Nt = size(X_test, 1);

if K>Np || K>Nn
    K = min(Np, Nn);
    fprintf('Warning: K is larger than Np or Nn!\n');
end

flag_removal = false(Np*Nn+Nt*Nn+Nt*Np, 1);

if flag_training
    [B_PN, IX_PN] = sort(dist_PN, 2);
    for i=1: Np
        for j=K+1: Nn
            flag_removal((i-1)*Nn+IX_PN(i, j), 1) = true;
        end
    end
end

[B_UN, IX_UN] = sort(dist_UN, 2);
start2 = Np*Nn;
for i=1: Nt
    for j=K+1: Nn
        flag_removal(start2+(i-1)*Nn+IX_UN(i, j), 1) = true;
    end
end

[B_UP, IX_UP] = sort(dist_UP, 2);
start3 = Np*Nn + Nt*Nn;
for i=1: Nt
    for j=K+1: Np
        flag_removal(start3+(i-1)*Np+IX_UP(i, j), 1) = true;
    end
end