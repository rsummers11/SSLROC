% The format of training and testing data file is:
% <label> <index1>:<value1> <index2>:<value2> ...

function [] = libsvm_input(Y, X, filename)

fid=fopen(filename,'w+');

[N, M] = size(X);

for i=1: N
    fprintf(fid, '%d ', Y(i));
    for j=1: M
        if X(i,j) ~= 0
            fprintf(fid, '%d:%f ', j, X(i,j));
        end
    end
    fprintf(fid, '\n');
end

fclose(fid);