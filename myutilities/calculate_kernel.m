% read data and calculate similarity
function [K] = calculate_kernel(X1, X2, para)
clock_start = clock;
fprintf('Begin of calculate_kernel.\n');

switch lower(para.type)
    case 'rbf'
        % calculate similarity between selected samples
        K = rbf(X1, X2, para.para1);
    case 'rbf_kernel_text'
        K = rbf_kernel_text(X1, para.width_RBF);
    case 'linear'
        K = linear(X1, X2);  
    case 'polynomial'
        K = polynomial_kernel(X1, X2, para.para1); 
    case 'geodesic_kernel'
        K = geodesic_kernel(X1, para.num_neighbor);             
    case 'cluster_kernel'
        K = cluster_kernel(X1, para.width_RBF);     
    case 'geodesic_cluster_kernel'
        K = geodesic_cluster_kernel(X1, para.num_neighbor);     
    case 'markov_kernel'
        K = Markov_kernel(X1, para.t);  
    case 'euclidian'
        K = Euclidian(X1);  
    case 'inverse_euclidian'
        K = inverse_Euclidian(X1);
    case 'laplacian_rbf'
        K = laplacian_rbf(X1, X2, para.para1);     
    case 'kappa_square'
        K = kappa_square(X1, X2, para.para1);     
    case 'non_gaussian_rbf'
        K = non_gaussian_rbf(X1, X2, para.para1, para.para2, para.para3);          
    case 'weighted_linear'
        K = weighted_linear(X1, X2, para.A);
    case 'earth_mover'
        K = earth_mover(X1);        
    otherwise
        disp('Unknown para!');
end
timespan = etime(clock, clock_start);
fprintf('End of calculate_kernel. Time used: %5.3f seconds.\n', timespan);


% ******************************************
% use linear para to calculate similarity
function K = linear(X1, X2)
if isempty(X2)
    K = X1 * X1';
else
    K = X1 * X2';
end

% ******************************************
% use linear para to calculate similarity
function K = weighted_linear(X1, X2, A)
if isempty(X2)
    K = X1 * A * X1';
else
    K = X1 * A * X2';
end


% ******************************************
% use linear para to calculate similarity
function K = polynomial_kernel(X1, X2, p)

if isempty(X2)
    D = X1 * X1';
    K = (D + 1) .^ p;
%     N = size(X1, 1);
%     K = zeros(N);
%     for i=1: N
%         for j=1: i
%             d = X1(i, :) * X1(j, :)';
%             K(i, j) = (d + 1)^p;
%             K(j, i) = K(i, j);
%         end
%     end    
else
    D = X1 * X2';
    K = (D + ones(size(D))) .^ p;    
%     N1 = size(X1, 1);
%     N2 = size(X2, 1);
%     K = zeros(N1, N2);
%     for i=1: N1
%         for j=1: N2
%             d = X1(i, :) * X2(j, :)';
%             K(i, j) = (d + 1)^p;
%         end
%     end    
end

% ******************************************
% use RBF para to calculate similarity
function K = rbf(X1, X2, sigma)

if isempty(X2)
    N = size(X1, 1);
    P=sum(X1.*X1,2);
    K = exp(-1*sigma*(repmat(P',N,1) + repmat(P,1,N) - 2*X1*X1'));        
else
    N1 = size(X1, 1);
    N2 = size(X2, 1);
    
    P1=sum(X1.*X1,2);
    P2=sum(X2.*X2,2);
    K = exp(-1*sigma*(repmat(P1,1,N2) + repmat(P2',N1,1) +  - 2*X1*X2'));  
%     for i=1: N1
%         for j=1: N2
%             d = sum(abs(X1(i, :) - X2(j, :)) .^ 2);
%             K(i, j) = exp(-1 * d * sigma);
%         end
%     end 
end

% ******************************************
% calculate cluster_kernel
% Cluster kernels for semi-supervised learning, NIPS 2002
function K = cluster_kernel(X, sigma)
fprintf('Begin of cluster kernel.\n');
N = size(X, 1);

% calculate RBF kernel
K = rbf_kernel(X, sigma);

% calculate D
sum_row = sum(K, 2);
D1 = diag(sum_row);

L = D1^(-1/2)*K*D1^(-1/2);

% eigendecomposition
[V,D] = eig(L);

% step transfer function

% find max 2 eigenvalues, set corresponding D(i,i) = 1, others 0
diagonal = zeros(N, 1);
for i=1: N
    diagonal(i) = D(i, i);
end
[B IX] = sort(diagonal, 'descend');
for i=1: N
    % keep first two max eigenvalues
    if i==IX(1) || i==IX(2)
        D(i, i) = 1;
    else
        D(i, i) = 0;
    end
end

% calculate new kernel
Ln = V*D*V';
Dn = zeros(N);
for i=1: N
    Dn(i, i) = 1/Ln(i, i);
end
Kn = Dn^(1/2)*Ln*Dn^(1/2);
K = Kn;
fprintf('End of the calculation of cluster kernel.\n');


% ******************************************
% calculate cluster_kernel
% Cluster kernels for semi-supervised learning, NIPS 2002
function K = geodesic_cluster_kernel(X, num_neighbor)

N = size(X, 1);

% calculate geodesic kernel
K = geodesic_distance(X, num_neighbor);

% calculate D
D = zeros(N);
for i=1: N
    K(i, i) = 1;
    D(i, i) = sum(K(i, :));
end

L = D^(-1/2)*K*D^(-1/2);

% eigendecomposition
[V,D] = eig(L);

% step transfer function

% find max 2 eigenvalues, set corresponding D(i,i) = 1, others 0
diagonal = zeros(N, 1);
for i=1: N
    diagonal(i) = D(i, i);
end
[B IX] = sort(diagonal, 'descend');
for i=1: N
    % keep first two max eigenvalues
    if i==IX(1) || i==IX(2)
        D(i, i) = 1;
    else
        D(i, i) = 0;
    end
end

% calculate new kernel
Ln = V*D*V';
Dn = zeros(N);
for i=1: N
    Dn(i, i) = 1/Ln(i, i);
end
Kn = Dn^(1/2)*Ln*Dn^(1/2);
K = Kn;
fprintf('End of the calculation of cluster kernel.\n');


% ******************************************
function K = geodesic_kernel(X, num_neighbor)

K = geodesic_distance(X, num_neighbor);

% ******************************************
function K = Markov_kernel(X, t)
N = size(X, 1);
D = zeros(N);

% ????????
% for i=1: N
%     for j=1: i-1
%         D(i, j) = sum((X(i,:) - X(j,:)).^2);
%         D(j, i) = D(i, j);
%     end
%     D(i, i) = 0;
% end

% rbf distance
D = rbf_kernel(X, 0.8);

% ????????????
P = zeros(N);
for i=1: N
    P(i, :) = D(i, :) / sum(D(i, :));
end

K = P^t;



% ******************************************
% Laplacian RBF

function K = laplacian_rbf(X1, X2, sigma)

if isempty(X2)
    D = dist_helper(single(X1), [], single(1));
    K = exp(-1*sigma*D);
else
    D = dist_helper(single(X1), single(X2), single(1));
    K = exp(-1*sigma*D);    
end

K = double(K);

% if size(X2, 1) > 0
%     N1 = size(X1, 1);
%     N2 = size(X2, 1);
%     K = zeros(N1, N2);
%     for i=1: N1
%         for j=1: N2
%             d = sum( abs(X1(i, :) - X2(j, :)) );
%             K(i, j) = exp(-1 * d * sigma);
%         end
%     end    
% else
%     N = size(X1, 1);
%     K = zeros(N);
%     for i=1: N
%         for j=1: i-1
%             d = sum( abs(X1(i, :) - X1(j, :)) );
%             K(i, j) = exp(-1 * d * sigma);
%             K(j, i) = K(i, j);
%         end
%          K(i, i) = 1;
%     end
% end

% ******************************************
% Kappa square

function K = kappa_square(X1, X2, sigma)

if size(X2, 1) > 0
    N1 = size(X1, 1);
    N2 = size(X2, 1);
    K = zeros(N2, N1);
    for i=1: N2
        for j=1: N1
            d = sum( ((X2(i, :) - X1(j, :)).^2) ./ (X2(i, :) + X1(j, :)) );
            K(i, j) = exp(-1 * d * sigma);
        end
    end    
else
    N = size(X1, 1);
    K = zeros(N);
    for i=1: N
        for j=1: i-1
            d = sum( ((X1(i, :) - X1(j, :)).^2) ./ (X1(i, :) + X1(j, :)) );
            K(i, j) = exp(-1 * d * sigma);
            K(j, i) = K(i, j);
        end
         K(i, i) = 1;
    end
end

% ******************************************
% Kappa square

function K = non_gaussian_rbf(X1, X2, sigma, a, b)

% if size(X2, 1) > 0
%     N1 = size(X1, 1);
%     N2 = size(X2, 1);
%     K = zeros(N2, N1);
%     
%     X1 = X1 .^ a;
%     X2 = X2 .^ a;
%     for i=1: N2
%         for j=1: N1
%             d = sum(abs(X2(i, :) - X1(j, :)) .^ b);
%             K(i, j) = exp(-1 * d * sigma);
%         end
%     end    
% else
%     N = size(X1, 1);
%     K = zeros(N);
%     X1 = X1 .^ a;
%     for i=1: N
%         for j=1: i-1
%             d = sum( abs((X1(i, :) - X1(j, :)) .^ b) );
%             K(i, j) = exp(-1 * d * sigma);
%             K(j, i) = K(i, j);
%         end
%          K(i, i) = 1;
%     end
% end

if isempty(X2)
    X1 = X1 .^ a;
    D = dist_helper(single(X1), [], single(b));
    K = exp(-1*sigma*D);
else
    X1 = X1 .^ a;
    X2 = X2 .^ a;    
    D = dist_helper(single(X1), single(X2), single(b));
    K = exp(-1*sigma*D);    
end

K = double(K);

function K = Euclidian(X)
if exist('X','var')
    dim=size(X,2);
    n1=size(X,1);
end

P=sum(X.*X,2);
K = sqrt(repmat(P',n1,1) + repmat(P,1,n1) - 2*X*X'); 


% ******************************************

function K = inverse_Euclidian(X)
[N M] = size(X);

P=sum(X.*X,2);
K = sqrt(repmat(P',N,1) + repmat(P,1,N) - 2*X*X'); 

% check zero distance, set it as 1.
K(find(K<1e-10)) = 1;
% for i=1:N
%     for j=1: i
%         if K(i, j) == 0
%             K(i, j) = 1;
%             K(j, i) = 1;
%         end
%     end
% end

K = 1./K;




% ******************************************
% use RBF para to calculate similarity
function K = rbf_kernel_text(X, sigma)
N = size(X, 1);
% length of every instance
L = zeros(N, 1);
for i=1: N
    d = X(i,:) * X(i,:)';
    L(i) = d^(1/2);
end
% similarity
K = zeros(N);
for i=1: N
    for j=1: i-1
        d = X(i, :) * X(j, :)';
        d = 1 - d / (L(i) * L(j));
        K(i, j) = exp(-1*d / (2 * sigma^2));
        K(j, i) = K(i, j);
    end
    K(i, i) = 0;
end



% ******************************************

function K = earth_mover(X)
[N M] = size(X);

for i=1: N
    for j=1: N
        % Features
        f1 = [1:M]';
        f2 = [1:M]';

        % Weights
        w1 = X(i,:)' / sum(X(i,:));
        w2 = X(j,:)' / sum(X(j,:));

        % Earth Mover's Distance
        [f, fval] = emd(f1, f2, w1, w2, @gdf);
        K(i, j) = fval;
    end
end


