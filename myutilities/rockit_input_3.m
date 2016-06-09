% create ROCKIT input file
function rockit_input_3(Y, dv1, dv2, dv3)

filename = 'rockit_input.prn';

fid=fopen(filename,'w+');

fprintf(fid, 'ROCKIT input file\n');
fprintf(fid, 'KIT	\n');
fprintf(fid, '"Method1"	"Method2"	"Method3"\n');
fprintf(fid, 'CLL	CLL	CLL\n');

for i=1: length(Y)
    if Y(i) < 0
        fprintf(fid, '%f\t%f\t%f\n', dv1(i), dv2(i), dv3(i));
    end
end

fprintf(fid, '*\t*\t*\n');

for i=1: length(Y)
    if Y(i) > 0
        fprintf(fid, '%f\t%f\t%f\n', dv1(i), dv2(i), dv3(i));
    end
end

fprintf(fid, '\t*\t*\t*\n');

fclose(fid);
