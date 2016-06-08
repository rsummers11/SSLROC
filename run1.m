clear;
clc;
method = 4;

diary('screen_output.txt');
% datasets = [2:38];
datasets = [37];
for d = datasets
    mass_runner_swarm(d, method)
    % screen_output{d} = evalc(mass_runner_swarm(d));
end

% save screen_output screen_output

diary off;