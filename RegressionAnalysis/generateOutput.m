function x = generateOutput(stats, prefix)

filename = strcat(prefix,'_results.mat');
save(filename, 'stats', '-v7.3');
x = 0;
end