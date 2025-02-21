classdef MinGWCallbackBase
    properties(Constant)
        InstallPath = utils.setOpenBLASPath('C:\bin\OpenBLAS-0.3.28-x64', 'full')
        LibName = 'libopenblas'
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

            libPriority = '';
            libPreCompiled = true;
            libLinkOnly = true;
            libPath = fullfile(openBLAS.windows.MinGWCallbackBase.InstallPath, 'lib');
            incPath = fullfile(openBLAS.windows.MinGWCallbackBase.InstallPath, 'include');

            % Check if the target is not PIL or the generate code only
            % setting is on for non-simulink configurations
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet')
                if ~ctx.ConfigData.GenCodeOnly && ~strcmp(ctx.ConfigData.VerificationMode, 'PIL')
                    % Error if callback used is not on Windows
                    assert(ispc, 'The BLAS/LAPACK callback class currently specified in the code generation configuration is intended for Windows only. Please use the appropriate class for your operating system');

                    % Error if library path does not exist
                    assert(exist(libPath, "dir"),...
                        'The library directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', libPath);

                    % Error if include path does not exist
                    assert(exist(incPath, "dir"),...
                        'The include directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', incPath);
                end
            end

            if isStatic
                libName = append(openBLAS.windows.MinGWCallbackBase.LibName, '.a');
                gccVersion = '';
                mingwLoc = getenv("MW_MINGW64_LOC");
                if ~isempty(mingwLoc)
                    [out, gccVersion] = system([fullfile(mingwLoc, 'bin', 'gcc'), ' -dumpversion']);
                    if ~out
                        gccVersion = strip(gccVersion);
                    end
                end
                libLoc = fullfile(mingwLoc, 'lib', 'gcc', 'x86_64-w64-mingw32', gccVersion);
                if exist(libLoc, 'dir') == 7
                    buildInfo.addSysLibs({'gfortran', 'quadmath'}, libLoc);
                else
                    buildInfo.addSysLibs({'gfortran', 'quadmath'});
                end
            else
                libName = append(openBLAS.windows.MinGWCallbackBase.LibName, '.dll.a');
                setenv("PATH", append(getenv("PATH"), pathsep, fullfile(openBLAS.windows.MinGWCallbackBase.InstallPath, 'lib')));
                setenv("PATH", append(getenv("PATH"), pathsep, fullfile(openBLAS.windows.MinGWCallbackBase.InstallPath, 'bin')));
            end

            buildInfo.addLinkObjects(libName, libPath, ...
                libPriority, libPreCompiled, libLinkOnly);
            buildInfo.addIncludePaths(incPath);
            if strcmp(ctx.getTargetLang, 'C++')
                buildInfo.addDefines('HAVE_COMPLEX_STURCTURE');
                % The -Wno-pedantic flag may be required to get some versions of OpenBLAS work with MATLAB
                % coder when generating C++ code. Uncomment the next line when required.
                % buildInfo.addCompileFlags('-Wno-pedantic');
            end
        end
    end
end
