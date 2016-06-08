clear;

% datasets = [2:38];
datasets = [104];

flag_SVM = 0;
flag_SVMROC = 0;
flag_RankBoost = 0;
flag_OPAUC = 0;
flag_SVMlin = 0;
flag_SSRankBoost = 0;        
flag_SSL1 = 1;% norm 1 SSLROC
flag_SSL2 = 1;% norm 2 SSLROC




% filename = sprintf('my_swarm_20140609.cmd');
filename = sprintf('my_swarm_20140613_mturk.cmd');

fid=fopen(filename,'w+');

% SVM
if flag_SVM
    method = 1;
    % C
    P1 = [-4:1:2];
    P2 = [];
    write_script(fid, method, datasets, P1, P2);
end

% SVMROC
if flag_SVMROC
    method = 2;
    % C
    P1 = [-4:1:2];
    P2 = [];
    write_script(fid, method, datasets, P1, P2);
end

% RankBoost
if flag_RankBoost
    method = 3;
    % number of weak learners
    P1 = [30:10:90];
    P2 = [];
    write_script(fid, method, datasets, P1, P2);
end

% OPAUC
if flag_OPAUC
    method = 4;
    % eta
    P1 = [-12:1:10];
    % lambda
    P2 = [-10:1:2];
    write_script(fid, method, datasets, P1, P2);
end

% SVMlin
if flag_SVMlin
    method = 5;
    % Large Scale Semi-supervised Linear SVMs
    % lambda  -W  regularization parameter lambda   (default 1) 
    P1 = [-4:1:4];
    % lambda' -U  regularization parameter lambda_u (default 1)
    P2 = [-2:1:2];
    write_script(fid, method, datasets, P1, P2);
end

% SSRankBoost
if flag_SSRankBoost
    method = 6;
    % A Boosting Algorithm for Learning Bipartite Ranking Functions with Partially Labeled Data
    % -l    (float) 	The discount factor regularizing the impact of the objective term over unlabeled examples in the learning process. If -l is not specified, the program corresponds to the supervised RankBoost algorithm for bipartite ranking [Freund et al. 2003],
    P1 = [0 0.2 0.4 0.6 0.8 1];
    % -k   (integer) 	The number of unlabeled examples which are given the same relevance judgment than their most nearest labeled neighbor (default 3),    
    P2 = [1:10];
    write_script(fid, method, datasets, P1, P2);
end

% SSL1
if flag_SSL1
    method = 7;
%     % C1
%     P1 = [-1 0 1];
%     % C2
%     P2 = [-2 -1 0];
    % C1=C2
    % P1 = [-1 0 1];
    P1 = [-3 -2 -1 0 1];
    % M
    P2 = [-1 0 1];
    write_script(fid, method, datasets, P1, P2);
end

% SSL2
if flag_SSL2
    method = 8;
%     % C1
%     P1 = [-1 0 1];
%     % C2
%     P2 = [-2 -1 0];
    % C1=C2
    % P1 = [-1 0 1];
    P1 = [-3 -2 -1 0 1];
    % M
    P2 = [-1 0 1];
    write_script(fid, method, datasets, P1, P2);
end


fclose(fid);