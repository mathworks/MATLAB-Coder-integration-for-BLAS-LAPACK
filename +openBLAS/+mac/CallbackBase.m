classdef CallbackBase
    properties(Constant)
        LibPath = utils.setOpenBLASPath('/opt/homebrew/opt/openblas/lib', 'lib')
        IncludePath = utils.setOpenBLASPath('/opt/homebrew/opt/openblas/include', 'include')
        % Update the below path if a custom omp library installation is available
        OmpPath = fullfile(matlabroot, 'bin', 'maca64')

        MainLib = 'openblas'
        OtherLibs = {'pthread'}
        StaticLib = {'omp'}
    end

    methods (Static)
        function updateBuildInfo(buildInfo, ctx)
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet') && strcmp(ctx.ConfigData.OutputType, 'LIB')
                isStatic = true;
            else
                % Branch for dll and exe
                % Simulink code will be linked dynamically
                isStatic = false;
            end
            % Check if the target is not PIL or the generate code only
            % setting is on for non-simulink configurations
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet')
                if ~ctx.ConfigData.GenCodeOnly && ~strcmp(ctx.ConfigData.VerificationMode, 'PIL')
                    % Error if callback used is not on Windows
                    assert(ismac, 'The BLAS/LAPACK callback class currently specified in the code generation configuration is intended for MAC only. Please use the appropriate class for your operating system');

                    % Error if library path does not exist
                    libPath = openBLAS.mac.CallbackBase.LibPath;
                    assert(exist(libPath, "dir"),...
                        'The library directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', libPath);

                    % Error if include path does not exist
                    incPath = openBLAS.mac.CallbackBase.IncludePath;
                    assert(exist(incPath, "dir"),...
                        'The include directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', incPath);
                end
            end

            if isStatic
                libName = append('lib', openBLAS.mac.CallbackBase.MainLib);
                libPriority = '';
                libPreCompiled = true;
                libLinkOnly = true;
                buildInfo.addLinkObjects(libName, openBLAS.mac.CallbackBase.LibPath,...
                   libPriority , libPreCompiled, libLinkOnly);
                buildInfo.addSysLibs(openBLAS.mac.CallbackBase.StaticLib);
            else
                buildInfo.addLinkFlags(['-Wl,-rpath,' openBLAS.mac.CallbackBase.LibPath]);
                buildInfo.addLinkFlags(['-L' openBLAS.mac.CallbackBase.LibPath]);
                buildInfo.addSysLibs(openBLAS.mac.CallbackBase.MainLib);
                setenv("DYLD_FALLBACK_LIBRARY_PATH", append(getenv("DYLD_FALLBACK_LIBRARY_PATH"), pathsep, openBLAS.mac.CallbackBase.LibPath));
            end

            buildInfo.addSysLibs(openBLAS.mac.CallbackBase.OtherLibs);

            buildInfo.addIncludePaths(openBLAS.mac.CallbackBase.IncludePath);
            buildInfo.addLinkFlags(['-L' openBLAS.mac.CallbackBase.OmpPath]);
        end
    end
end
