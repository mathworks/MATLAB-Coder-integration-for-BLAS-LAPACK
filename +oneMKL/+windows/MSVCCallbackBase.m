classdef (Abstract) MSVCCallbackBase
    properties(Constant)
        InstallPath = utils.setOneAPIPath('C:\Program Files (x86)\Intel\oneAPI')
        LibNamesCommon = {'mkl_intel_ilp64', 'mkl_core'}
    end

    properties(Constant, Abstract)
        LibNames
    end

    methods (Static)
        function updateBuildInfoHelper(buildInfo, ctx, libNames)
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet') && strcmp(ctx.ConfigData.OutputType, 'LIB')
                isStatic = true;
            else
                % Branch for dll and exe
                % Simulink code will be linked dynamically
                isStatic = false;
            end

            libPriority = '';
            libPreCompiled = true;
            libLinkOnly = true;

            MKLRoot = fullfile(oneMKL.windows.MSVCCallbackBase.InstallPath, 'mkl', 'latest');
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

            allLibs = [oneMKL.windows.MSVCCallbackBase.LibNamesCommon, libNames];
            if isStatic
                libName = append(allLibs, '.lib');
            else
                libName = append(allLibs, '_dll.lib');
                setenv("PATH", append(getenv("PATH"), pathsep, MKLRootLib));
                setenv("PATH", append(getenv("PATH"), pathsep, fullfile(MKLRoot, 'bin')));
            end

            buildInfo.addLinkObjects(libName, MKLRootLib, libPriority, libPreCompiled, libLinkOnly);

            buildInfo.addIncludePaths(incPath);
            buildInfo.addDefines('-DMKL_ILP64');
        end
    end
end
