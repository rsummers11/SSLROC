% save result using txt files
% works for LOO
function [] = save_result(name_method, Y, dv)

global path_result;

% filename = sprintf('../../result/cancerwbc/%s_%d.txt', name_method, no_patient);
filename = sprintf('%s%s.txt', path_result, name_method);

fid=fopen(filename,'w+');

N = length(Y);

for i=1: N
    fprintf(fid, '%d %f\n', Y(i), dv(i));
end

fclose(fid);