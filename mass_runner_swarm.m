function [] = mass_runner_swarm(nDataset, method)

if ~isunix
    if 1 && matlabpool('size') == 0
        matlabpool open 10;
    end    
end

if ischar(nDataset)
    nDataset = str2num(nDataset);
end

switch method
    case 1 % SVM
        % C
        P1 = [-4:1:2];
        P2 = [];
        
    case 2 % SVMROC
        % C
        P1 = [-4:1:2];
        P2 = [];

    case 3 % RankBoost
        % number of weak learners
        P1 = [30:10:90];
        P2 = [];

    case 4 % OPAUC
        % eta
        % P1 = [-12:1:10];
        P1 = [-12:1:10];
        % lambda
        P2 = [-10:1:2];
        
    case 5 % SVMlin
        % Large Scale Semi-supervised Linear SVMs
        % lambda  -W  regularization parameter lambda   (default 1) 
        % P1 = [-4:1:4];
        P1 = [-4:1:4];
        % lambda' -U  regularization parameter lambda_u (default 1)
        P2 = [-2:1:2];

    case 6 % SSRankBoost
        % A Boosting Algorithm for Learning Bipartite Ranking Functions with Partially Labeled Data
        % -l    (float) 	The discount factor regularizing the impact of the objective term over unlabeled examples in the learning process. If -l is not specified, the program corresponds to the supervised RankBoost algorithm for bipartite ranking [Freund et al. 2003],
        P1 = [0 0.2 0.4 0.6 0.8 1];
        % P1 = [0.6 0.8 1];
        % -k   (integer) 	The number of unlabeled examples which are given the same relevance judgment than their most nearest labeled neighbor (default 3),    
        %P2 = [1:10];
        P2 = [1:10];

    case {7,8} % SSL
        % C1
        P1 = [-3 -2 -1 0 1];
        % C2
        P2 = [-1 0 1];
        
    otherwise
        warning('Unknown method. \n');
        exit(0);
end

parfor i=1:length(P1)
    if isempty(P2)
        experiment(method, nDataset, P1(i));
    else
        for j=1:length(P2)
            experiment(method, nDataset, P1(i), P2(j));
        end
    end
end

if ~isunix
    matlabpool close;
end