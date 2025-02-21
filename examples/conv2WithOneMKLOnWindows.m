%% Initial setup
rng(11, 'twister');

%% Time the implementations
addpath('..');

cfg1 = coder.config('lib');

cfg2 = coder.config('lib');
cfg2.CustomBLASCallback='oneMKL.windows.OpenMPBLASCallback';
cfg2.CustomLAPACKCallback='oneMKL.windows.OpenMPLAPACKCallback';

A = rand(2000, 2000);
B = rand(30, 30);

%% Generate Code with cfg2 and verify the results
cfg2.VerificationMode = 'SIL';
codegen conv2Wrapper -args {A, B} -config cfg2

CML = conv2(A, B);
CCG = conv2Wrapper_sil(A, B);
fprintf("Difference in result: %e\n", max(abs(CML(:)-CCG(:))));

%% Time the configurations
tWoCB = coder.timeit('conv2Wrapper', 1, {A, B},'CoderConfig', cfg1, 'CompileArgs', {coder.typeof(1, [Inf, Inf]), coder.typeof(1, [Inf, Inf])});
tCB = coder.timeit('conv2Wrapper', 1, {A, B},'CoderConfig', cfg2, 'CompileArgs', {coder.typeof(1, [Inf, Inf]), coder.typeof(1, [Inf, Inf])});

f = @() conv2(A, B);
tML = timeit(f);

fprintf("Time taken by MATLAB: %f\n", tML);
fprintf("Time taken by codegen without callback: %f\n", tWoCB);
fprintf("Time taken by codegen with MKL callback: %f\n", tCB);

