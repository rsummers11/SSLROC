function [Km_train, Km_test_train, A, M, eigenvalues] = MyMapping(Y_train, X_train, X_test, Para)

epsilon = Para.epsilon;
regu =  Para.regu;
% regu = epsilon;
[num_train, num_dimensions] = size(X_train);
% num_test = size(X_test, 1);

A = [];
M = [];
eigenvalues = [];

% target matrix
D = zeros(num_train);
for i=1: num_train
    for j=1: num_train
        if Y_train(i) == Y_train(j)
            D(i, j) = 1;
        end
    end
end

if Para.flag_kernel
    % calculate kernel matrices 
    K_train = calculate_kernel(X_train, [], Para.kernel);
    K_test_train = calculate_kernel(X_test, X_train, Para.kernel);    

    % using the Woodbury identity
    % B = inv(D' + K_train / epsilon);
    B = inv(D' + K_train / epsilon + regu * eye(num_train));
    
    % kernel matrix of train samples in mapping feature space
    Km_train = (1/epsilon)*K_train - (1/epsilon^2)*K_train*B*K_train;
    
    % kernel matrix of test-train samples in mapping feature space
    Km_test_train = (1/epsilon)*K_test_train - (1/epsilon^2)*K_test_train*B*K_train';



    % % using the Kailath variant
    % inv_D = inv(D' + regu * eye(num_train));
    % B = inv(eye(num_train) + (1 / epsilon) * K_train * inv_D);
    % 
    % % kernel matrix of train samples in mapping feature space
    % Km_train = (1/epsilon) * K_train - (1/epsilon^2) * K_train * inv_D * B * K_train;
    % 
    % % kernel matrix of test-train samples in mapping feature space
    % Km_test_train = (1/epsilon) * K_test_train - (1/epsilon^2) * K_test_train * inv_D * B * K_train';

else% using linear kernel
    
    A = inv(X_train'*(inv(D + regu * eye(num_train)))'*X_train + epsilon*eye(num_dimensions));
    %A = inv(X_train'*(inv(D))'*X_train + epsilon*eye(M));

    % guarantee A to be symmetric
    A = max(A, A'); 
    
    M = sqrtm(A);    
    
%     % for dimension reduction
%     % mapping matrix
%     [V, D] = eig(A);
%     eigenvalues = diag(D);
%     [sorted, idx] = sort(eigenvalues, 'descend');
%     eigenvalues = eigenvalues(idx);
%     V = V(:, idx);
%     dimension_low = Para.dimension_low;
%     M = diag(eigenvalues(1: dimension_low) .^ 0.5) * V(:, 1: dimension_low)';
%     Km_train = X_train * M'*M * X_train';
%     Km_test_train = X_test * M'*M * X_train';
    
    Km_train = X_train * A * X_train';
    Km_test_train = X_test * A * X_train';
end





% Km_train = zeros(num_train);
% for i=1: num_train
%     for j=1: num_train
%         Km_train(i, j) = (1/epsilon)*K_train(i, j) - (1/epsilon^2)*K_train(i, :)*B*K_train(:, j);
%     end
% end
% 
% Km_test_train = zeros(num_test, num_train);
% for i=1: num_test
%     for j=1: num_train
%         Km_test_train(i, j) = (1/epsilon)*K_test_train(i, j) - (1/epsilon^2)*K_test_train(i, :)*B*(K_train(j, :))';
%     end
% end