% create ROCKIT input file
function rockit_input(Y, dv1, dv2)

filename = 'rockit_input.prn';

fid=fopen(filename,'w+');

fprintf(fid, 'Kidney Cancer Detection\n');
fprintf(fid, 'KIT	\n');
fprintf(fid, '"HCF"	"MS"\n');
fprintf(fid, 'CLL	CLL\n');

for i=1: length(Y)
    if Y(i) < 0
        fprintf(fid, '%f\t%f\n', dv1(i), dv2(i));
    end
end

fprintf(fid, '*	*\n');

for i=1: length(Y)
    if Y(i) > 0
        fprintf(fid, '%f\t%5.3f\n', dv1(i), dv2(i));
    end
end

fprintf(fid, '*	*\n');

fclose(fid);