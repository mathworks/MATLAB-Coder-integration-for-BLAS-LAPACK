%% Initial setup
rng(11, 'twister');

%% Time the implementations
addpath('..');

cfg1 = coder.config('lib');

cfg2 = coder.config('lib');
cfg2.CustomBLASCallback='openBLAS.linux.BLASCallback';
cfg2.CustomLAPACKCallback='openBLAS.linux.LAPACKCallback';

A = rand(4000, 4000);

tWithoutCallback = coder.timeit('invWrapper', 1, {A}, 'CoderConfig', cfg1, 'CompileArgs', {coder.typeof(1, [Inf, Inf])});
tWithCallback = coder.timeit('invWrapper', 1, {A}, 'CoderConfig', cfg2, 'CompileArgs', {coder.typeof(1, [Inf, Inf])});

fprintf("Time taken by codegen without callback: %f\n", tWithoutCallback);
fprintf("Time taken by codegen with OpenBLAS callback: %f\n", tWithCallback);
