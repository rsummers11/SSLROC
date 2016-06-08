function [] = write_script(fid, no_method, datasets, P1, P2)

for i=1:length(P1)
    for d=datasets
        if isempty(P2)
            fprintf(fid, './run_swarm_roc.sh /usr/local/matlab64 %d %d %d > temp/tdlout_%d_%d_%d\n', no_method, d, P1(i), no_method, d, P1(i));
        else
            for j=1:length(P2)
                fprintf(fid, './run_swarm_roc.sh /usr/local/matlab64 %d %d %d %d > temp/tdlout_%d_%d_%d_%d\n', no_method, d, P1(i), P2(j), no_method, d, P1(i), P2(j));
            end
        end
    end
end