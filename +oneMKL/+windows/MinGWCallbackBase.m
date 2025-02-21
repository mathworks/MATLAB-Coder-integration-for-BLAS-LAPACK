classdef (Abstract) MinGWCallbackBase
    properties(Constant)
        InstallPath = utils.setOneAPIPath('C:\Program Files (x86)\Intel\oneAPI')
        LibNames = {'mkl_sequential', 'mkl_rt', 'mkl_core', 'mkl_intel_lp64'}
    end

    methods (Static)
        function updateBuildInfo(buildInfo, ctx)
            libPriority = '';
            libPreCompiled = true;
            libLinkOnly = true;

            MKLRoot = fullfile(oneMKL.windows.MinGWCallbackBase.InstallPath, 'mkl', 'latest');
            MKLRootLib = fullfile(MKLRoot, 'lib');
            incPath = fullfile(MKLRoot, 'include');

            % Check if the target is not PIL or the generate code only
            % setting is on for non-simulink configurations
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet')
                if ~ctx.ConfigData.GenCodeOnly && ~strcmp(ctx.ConfigData.VerificationMode, 'PIL')
                    % Error if callback used is not on Windows
                    assert(ispc, 'The BLAS/LAPACK callback class currently specified in the code generation configuration is intended for Windows only. Please use the appropriate class for your operating system');

                    % Error if library path does not exist
                    assert(exist(MKLRootLib, "dir"),...
                        'The library directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OneAPI library', MKLRootLib);

                    % Error if include path does not exist
                    assert(exist(incPath, "dir"),...
                        'The include directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OneAPI library', incPath);
                end
            end
            
            buildInfo.addLinkObjects(oneMKL.windows.MinGWCallbackBase.LibNames, MKLRootLib, ...
                libPriority, libPreCompiled, libLinkOnly);

            setenv("PATH", append(getenv("PATH"), pathsep, MKLRootLib));
            setenv("PATH", append(getenv("PATH"), pathsep, fullfile(MKLRoot, 'bin')));

            buildInfo.addIncludePaths(incPath);
        end
    end
end
