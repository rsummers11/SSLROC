clear;
clc;
method = 6;

diary('screen_output_6.txt');
%datasets = [2:38];
datasets = [38];
for d = datasets
    mass_runner_swarm(d, method)
    % screen_output{d} = evalc(mass_runner_swarm(d));
end

% save screen_output screen_output

diary off;