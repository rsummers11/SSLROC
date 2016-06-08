% optimize AUROC using SDP
function [d_double, output] = ROC_SSL(Y_training, X_training, X_test, para)


%% construct kernel for SDP_SSL optimization

% divide training set into true/false groups
[X_training_P, X_training_N] = divide_TF(Y_training, X_training);

% kernel between true/false groups
K_training_PP = calculate_kernel(X_training_P, X_training_P, para.kernel);
K_training_NN = calculate_kernel(X_training_N, X_training_N, para.kernel);
K_training_PN = calculate_kernel(X_training_P, X_training_N, para.kernel);
K_training_NP = K_training_PN';

K_training_test_PU = calculate_kernel(X_training_P, X_test, para.kernel);
K_test_training_UP = K_training_test_PU';
K_training_test_NU = calculate_kernel(X_training_N, X_test, para.kernel);
K_test_training_UN = K_training_test_NU';

K_test_UU = calculate_kernel(X_test, X_test, para.kernel);


[Np, Nn] = size(K_training_PN);

% number of test samples
Nt = size(X_test, 1);

K_PNPN = zeros(Np*Nn);
for i=1: Np
    for j=1: Nn
        for u=1: Np
            for v=1: Nn
                % columnwise numbering
                % K_ROC((j-1)*Np+i, (v-1)*Np+u) = K_training_TT(i, u) - K_training_TF(i, v) - K_training_FT(j, u) + K_training_FF(j, v);
                
                % rowwise numbering
                K_PNPN((i-1)*Nn+j, (u-1)*Nn+v) = K_training_PP(i, u) - K_training_PN(i, v) - K_training_NP(j, u) + K_training_NN(j, v);                
            end
        end
    end
end

% K^PNUN
K_PNUN = zeros(Np*Nn, Nt*Nn);
for i=1: Np
    for j=1: Nn
        for u=1: Nt
            for v=1: Nn
                % rowwise numbering
                K_PNUN((i-1)*Nn+j, (u-1)*Nn+v) = K_training_test_PU(i, u) - K_training_PN(i, v) - K_training_test_NU(j, u) + K_training_NN(j, v);                
            end
        end
    end
end
K_UNPN = K_PNUN';

K_PNUP = zeros(Np*Nn, Nt*Np);
for i=1: Np
    for j=1: Nn
        for u=1: Nt
            for v=1: Np
                % rowwise numbering
                K_PNUP((i-1)*Nn+j, (u-1)*Np+v) = K_training_test_PU(i, u) - K_training_PP(i, v) - K_training_test_NU(j, u) + K_training_NP(j, v);                
            end
        end
    end
end
K_UPPN = K_PNUP';

K_UNUN = zeros(Nt*Nn, Nt*Nn);
for i=1: Nt
    for j=1: Nn
        for u=1: Nt
            for v=1: Nn
                % rowwise numbering
                K_UNUN((i-1)*Nn+j, (u-1)*Nn+v) = K_test_UU(i, u) - K_test_training_UN(i, v) - K_training_test_NU(j, u) + K_training_NN(j, v);                
            end
        end
    end
end

K_UNUP = zeros(Nt*Nn, Nt*Np);
for i=1: Nt
    for j=1: Nn
        for u=1: Nt
            for v=1: Np
                % rowwise numbering
                K_UNUP((i-1)*Nn+j, (u-1)*Np+v) = K_test_UU(i, u) - K_test_training_UP(i, v) - K_training_test_NU(j, u) + K_training_NP(j, v);                
            end
        end
    end
end
K_UPUN = K_UNUP';

K_UPUP = zeros(Nt*Np, Nt*Np);
for i=1: Nt
    for j=1: Np
        for u=1: Nt
            for v=1: Np
                % rowwise numbering
                K_UPUP((i-1)*Np+j, (u-1)*Np+v) = K_test_UU(i, u) - K_test_training_UP(i, v) - K_training_test_PU(j, u) + K_training_PP(j, v);                
            end
        end
    end
end


% regularization item
% K_ROC = K_ROC + 0.01*eye(Np*Nn);

%% parameter section for SDP
C1 = para.C1
C2 = para.C2
M = para.M;

%% SDP common section
switch para.solver
    case 'sedumi'
        % ops = sdpsettings('solver','sedumi','sedumi.eps',para.sedumi.eps,'verbose',1,'cachesolvers',0,'debug',0);% 'sedumi.eps',1e-6,
        ops = sdpsettings('solver','sedumi','sedumi.eps',para.sedumi.eps);
        fprintf('para.sedumi.eps=%f\n', para.sedumi.eps);
        % ops = sdpsettings('solver','sedumi');% PR 1st submission
    case 'sdpt3'
        % ops = sdpsettings('solver','sdpt3','sdpt3.maxit',para.sdpt3.maxit,'sdpt3.gaptol',para.sdpt3.gaptol,'verbose',1,'cachesolvers',0,'debug',0); % cutsdp; used in MICCAI draft
        ops = sdpsettings('solver','sdpt3','sdpt3.maxit',para.sdpt3.maxit,'sdpt3.gaptol',para.sdpt3.gaptol);
        % ops = sdpsettings('solver','sdpt3');
    otherwise
        ops = sdpsettings('solver','sedumi');
end
% ops = sdpsettings('solver','csdp','verbose',0,'cachesolvers',0,'debug',0);%
% ops = sdpsettings('solver','bmibnb','verbose',2);
% ops = sdpsettings('solver','cutsdp');
% ops = sdpsettings('solver','sedumi','verbose',1);
% yalmiptest(ops)
% yalmiptest(sdpsettings('solver','sdpt3'))

e3 = [0.5*C1*ones(Np*Nn,1); 0.5*C2*ones(Nt*Nn,1); 0.5*C2*ones(Nt*Np,1)];

d = sdpvar(Nt,1,'full');

for m=1: Nt
    for j=1: Nn
        dN((m-1)*Nn+j, 1) = M*(1-d(m)) - 1;
    end
end
for m=1: Nt
    for i=1: Np
        dP((m-1)*Np+i, 1) = M*d(m) - 1;
    end
end

d3 = [ones(Np*Nn,1); -1*dN; -1*dP];



t = sdpvar(1,1);
psi = sdpvar(Np*Nn+Nt*Nn+Nt*Np,1,'full');
zeta = sdpvar(Np*Nn+Nt*Nn+Nt*Np,1,'full');


%% SDP section

% regular single instance kernel learning paradigm
if para.flag_norm == 1
    % 1-norm soft margin
    K = [K_PNPN K_PNUN -1*K_PNUP; K_UNPN K_UNUN -1*K_UNUP; -1*K_UPPN -1*K_UPUN K_UPUP];
    % regularization of K
    if para.l1_loss.flag_regu
        if para.l1_loss.flag_fixed
            K = K + eye(size(K))/para.l1_loss.regu;
        else
            K = K + diag([ones(Np*Nn,1)/C1; ones(Nt*Nn,1)/C2; ones(Nt*Np,1)/C2]);
        end
    end
    % reduce SDP size by K-nearest neibor based deduction
    if para.SDP_reduction
        [flag_removal] = reduction_KNN(X_training_P, X_training_N, X_test, para.reduction);
        K(flag_removal, :) = [];
        K(:, flag_removal) = [];
        zeta(flag_removal) = [];
        psi(flag_removal) = [];
        d3(flag_removal) = [];
        e3(flag_removal) = [];
    end    
    K_Schur = [K (d3-psi+zeta)/sqrt(2); (d3-psi+zeta)'/sqrt(2) t-psi'*e3];
    F = [K_Schur>=0, psi>=0, zeta>=0, 1>=d>=0];    
elseif para.flag_norm == 2
    % 2-norm soft margin
    K = [K_PNPN+eye(Np*Nn)/C1 K_PNUN -1*K_PNUP; K_UNPN K_UNUN+eye(Nt*Nn)/C2 -1*K_UNUP; -1*K_UPPN -1*K_UPUN K_UPUP+eye(Nt*Np)/C2];
    
    % reduce SDP size by K-nearest neibor based deduction
    if para.SDP_reduction
        [flag_removal] = reduction_KNN(X_training_P, X_training_N, X_test, para.reduction);
        K(flag_removal, :) = [];
        K(:, flag_removal) = [];
        zeta(flag_removal) = [];
        d3(flag_removal) = [];
    end
    K_Schur = [K (d3+zeta)/sqrt(2); (d3+zeta)'/sqrt(2) t];
    F = [K_Schur>=0, zeta>=0, 1>=d>=0];      
else
    fprintf('Error: no norm defined!');
end

clear K_PNPN K_PNUN K_PNUP K_UNPN K_UNPN K_UNUP K_UPPN K_UPUN K_UPUP;
fprintf('Info: size of K = %d in SDP.\n', size(K, 1));

diagnostics = solvesdp(F, t, ops)
diagnostics.info

% whether the SDP solver failed on this problem
flag_fail = false;
% if strcmp(para.solver, 'sdpt3') && strcmp(diagnostics.info, 'Unknown error')
if strcmp(para.solver, 'sdpt3')
    % -1: 'Unknown error'; 1: 'infeasible problem'
    if diagnostics.problem==1 || diagnostics.problem==-1
        flag_fail = true;
    end
end

% checkset is used to examine satisfaction of constraints. 
checkset(F)


%% Output
output = [];

d3_double = double(d3);

% % convert vector to matrix
% dN_matrix = reshape(d3_double(Np*Nn+1: Np*Nn+Nt*Nn), Nn, Nt)';
% 
% dP_matrix = reshape(d3_double(Np*Nn+Nt*Nn+1: end), Np, Nt)';

d_double = double(d);

% output.dN_matrix = dN_matrix;
% output.dP_matrix = dP_matrix;
output.flag_fail = flag_fail;
