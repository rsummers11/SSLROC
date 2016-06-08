% load data
function [Y, X, name_dataset, anon] = load_data(path_data, para)

switch para.dataset %ask for specific example
        
    case 107 %for mnist data: extract digits 1 and 7
        %load mnist_4_9;
        
%         load mnist_all;
        N = Para.data.mnist.N;
        X = double([train4(1:Para.data.mnist.N/2, :); train9(1:Para.data.mnist.N/2, :)]);
        Y = [ones(Para.data.mnist.N/2,1); -1*ones(Para.data.mnist.N/2,1)];
        name_dataset = 'mnist_4_9';

    case 1 % 47
        name_dataset = 'soybean_s';     
        
    case 2 % 74
        name_dataset = 'cardio';        

    case 3 % 90
        name_dataset = 'post_op';
        para_best.SVM.C = 0.01;
        para_best.SDP.C = 0.01;
        para_best.SDP.ratio_ieta = 1; 
        
    case 4 % 101
        name_dataset = 'zoo';
        
    case 5 % 106
        name_dataset = 'breast';        
        
    case 6 % 120
        name_dataset = 'kidney_inflam';

    case 7 % 150
        name_dataset = 'iris'; 

    case 8 % 151
        name_dataset = 'teach';
        para_best.SVM.C = 0.1;
        para_best.SDP.C = 0.001;
        para_best.SDP.ratio_ieta = 10; 

    case 9 % 155
        name_dataset = 'hepatitis';

    case 10 % 178
        name_dataset = 'wine';
        para_best.SVM.C = 0.001;
        para_best.SDP.C = 0.001;
        para_best.SDP.ratio_ieta = 5;   
        
    case 11 % 195
        name_dataset = 'parkinsons';   
        
    case 12 % 208
        name_dataset = 'sonar';        

    case 13 % 214
        name_dataset = 'glass';
        
    case 14 % 267
        name_dataset = 'spectf';        

    case 15 % 270
        name_dataset = 'heart';
        para_best.SVM.C = 0.001;
        para_best.SDP.C = 0.001;
        para_best.SDP.ratio_ieta = 5;

    case 16 % 306
        name_dataset = 'survival';
        para_best.SVM.C = 1;
        para_best.SDP.C = 10;
        para_best.SDP.ratio_ieta = 100;
        
    case 17 % 336
        name_dataset = 'ecoli';
        
    case 18 % 345
        name_dataset = 'bupaliver';

    case 19 % 351
        name_dataset = 'ionosphere';
        para_best.SVM.C = 1;
        para_best.SDP.C = 1;
        para_best.SDP.ratio_ieta = 10; 
        
    case 20 % 366
        name_dataset = 'derm';        

    case 21 % 435
        name_dataset = 'house';
        para_best.SVM.C = 1;
        para_best.SDP.C = 0.1;
        para_best.SDP.ratio_ieta = 5;
        
    case 22 % 583
        name_dataset = 'indianliver';        

    case 23 % 625
        name_dataset = 'weight';
        para_best.SVM.C = 100;
        para_best.SDP.C = 100;
        para_best.SDP.ratio_ieta = 5;

    case 24 % 669
        name_dataset = 'cancer_wbc';
        para_best.SVM.C = 0.001;
        para_best.SDP.C = 0.001;
        para_best.SDP.ratio_ieta = 1;

    case 25 % 690
        name_dataset = 'statlog';% memory >70G
        para_best.SVM.C = 0.01;
        para_best.SDP.C = 0.1;
        para_best.SDP.ratio_ieta = 50; 
        
    case 26 % 748
        name_dataset = 'blood';
        para_best.SVM.C = 100;
        para_best.SDP.C = 100;
        para_best.SDP.ratio_ieta = 100;        

    case 27 % 768
        name_dataset = 'pima';
        para_best.SVM.C = 0.1;
        para_best.SDP.C = 100;
        para_best.SDP.ratio_ieta = 10;     
        
    case 28 % 846
        name_dataset = 'vehicle';            
        
    case 29 % 958
        name_dataset = 'tictactoe';
        
    case 30 % 1000
        name_dataset = 'credit_g';
        
    case 31 % 1473
        name_dataset = 'cmc';        
        
    case 32 % 3196
        name_dataset = 'kr_vs_kp';        
        
    case 33 % 4177
        name_dataset = 'abalone';
        
    case 34 % 8124
        name_dataset = 'mushroom';
        
    case 35 % 178
        name_dataset = 'wine2';
        
    case 36 % 1080
        name_dataset = 'cnae_9';      
        
    case 37 % 100
        name_dataset = 'arcene_train';       
        
    case 38 % 366
        name_dataset = 'derm2';        
end

fprintf('\n Processing dataset: %s\n', name_dataset);

% load data
filename = [path_data name_dataset];
workspace_loaded = load(filename);  
Y = workspace_loaded.Y;
X = workspace_loaded.X;

if ~isfield(workspace_loaded, 'anon')
    anon = [1:length(Y)]';
else
    % anon = workspace_loaded.mturk2_training_sorted_svmvote_AnonNumber_SVMVote_GrTrPolypID(:,1);
    anon = workspace_loaded.anon;    
end

% normalize features
switch para.feature.normalization
    case 'my_normalization'
        X = my_normalization(X);
    case 'ZScore'
        X = ZScore(X);
    otherwise
        X = my_normalization(X);
end

% N = min(100, length(Y));
N = length(Y);

% do not permute mturk2 dataset
if para.dataset < 100
    % randomize the original dataset
    idx = randperm(N);
    Y = Y(idx, :);
    X = X(idx, :);
end


% num_selected = min(100, length(Y));
% Y = Y(1:num_selected, :);
% X = X(1:num_selected, :);
