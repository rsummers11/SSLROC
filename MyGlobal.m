
% set parameters and global variables

global path_data;
global path_result;

if 1
    if isunix
        %path_data = '/home/wangshi/data/proj/roc/data/20110815/DifficultyTraining/';
        %path_data = '/home/wangshi/data/proj/roc/data/20111021/';
        path_data = '/home/wangshi/data/proj/roc/data/uci/';
        %path_data = '/home/wangshi/data/proj/roc/data/mturk2/';
        path_result = '/home/wangshi/data/proj/roc/result/';

        addpath(genpath('yalmip'));
  

%         addpath(genpath('csdp6'));
        addpath(genpath('csdp6.1.0linuxp4'));

        addpath(genpath('SeDuMi_1_3'));

        addpath(genpath('SDPT3-4.0'));

        addpath('DSDP5.8');    

        addpath('OPAUC');
        addpath('myutilities');

        addpath('mi');   
        addpath('mrmr');      

        addpath(genpath('SVM-KM'));

    elseif ispc
        flag_biowulf = 1;
        if flag_biowulf
            % path_data = 'Z:/proj/roc/data/20110815/DifficultyTraining/';
            path_data = 'Z:\proj\roc\data\uci/';
            path_result = 'Z:\proj\roc\result/';

            currentFolder = pwd;
            addpath(genpath(currentFolder));

        else
            path_data = 'C:\Users\lidg\Documents\MATLAB\'; 

    %         addpath('D:/tool/yalmip');

            addpath('C:\Users\lidg\Documents\MATLAB\yalmip');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\extras');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\demos');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\solvers');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\modules');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\modules\parametric');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\modules\moment');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\modules\global');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\modules\sos');
            addpath('C:\Users\lidg\Documents\MATLAB\yalmip\operators');  

            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3');
            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3\HSDSolver');
            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3\sdplib');
            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3\Solver');
            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3\Solver/Mexfun');
            addpath('C:\Users\lidg\Documents\MATLAB\SDPT3\dimacs');

            addpath('C:\Users\lidg\Documents\MATLAB\csdp6');
            addpath('C:\Users\lidg\Documents\MATLAB\csdp6\matlab');
            addpath('C:\Users\lidg\Documents\MATLAB\csdp6\bin');

            addpath('C:\Users\lidg\Documents\MATLAB\SeDuMi_1_3');

    %         addpath('D:/tool/MILL');


            addpath('C:\Users\lidg\Documents\MATLAB\myutilities');


        %     addpath('Z:\proj\mil\tool\shape_context');
        %     addpath('Z:\proj\mil\tool\HOG');
        end
    else
        disp('Warning: unknown operation system!');
    end
end
