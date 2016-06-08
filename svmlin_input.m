% The format of training and testing data file is:
% <label> <index1>:<value1> <index2>:<value2> ...

function [] = svmlin_input(Y, X, fn_label, fn_data)

[N, M] = size(X);

fid=fopen(fn_label,'w+');
for i=1: N
    fprintf(fid, '%d\n', Y(i));
end
fclose(fid);


fid=fopen(fn_data,'w+');
for i=1: N
    for j=1: M
        if X(i,j) ~= 0
            fprintf(fid, '%d:%f ', j, X(i,j));
        end
    end
    fprintf(fid, '\n');
end
fclose(fid);