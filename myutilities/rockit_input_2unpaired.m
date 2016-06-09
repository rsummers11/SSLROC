% create ROCKIT input file
function rockit_input_2unpaired(GrTrID1, dv1, GrTrID2, dv2)

filename = 'rockit_input.prn';

fid=fopen(filename,'w+');

fprintf(fid, 'Computer-aided Detection\n');
fprintf(fid, 'KIT	\n');
fprintf(fid, '"Method1"	"Method2"\n');
fprintf(fid, 'CLL	CLL\n');

% false positives
for i=1: length(GrTrID1)
    if GrTrID1(i) <= 0
        fprintf(fid, '%f\t#\n', dv1(i));
    end
end
for i=1: length(GrTrID2)
    if GrTrID2(i) <= 0
        fprintf(fid, '#\t%5.3f\n', dv2(i));
    end
end

% true positives
fprintf(fid, '*	*\n');

flag_processed = false(length(GrTrID2), 1);
% check GrTrID1
for i=1: length(GrTrID1)
    if GrTrID1(i) > 0
        flag_found = false;
        for j=1: length(GrTrID2)
            if GrTrID1(i) == GrTrID2(j)
                flag_found = true;
                flag_processed(j) = true;
            end
        end
        if flag_found
            fprintf(fid, '%f\t%f\n', mean(dv1(GrTrID1==GrTrID1(i))), mean(dv2(GrTrID2==GrTrID1(i))));
        else
            fprintf(fid, '%f\t%f\n', mean(dv1(GrTrID1==GrTrID1(i))), min(dv2));
        end
    end
end

% check GrTrID2
for i=1: length(GrTrID2)
    if GrTrID2(i) > 0 && ~flag_processed(i)
        fprintf(fid, '%f\t%f\n', min(dv1), mean(dv2(GrTrID2==GrTrID2(i))));
    end
end

fprintf(fid, '*	*\n');

fclose(fid);