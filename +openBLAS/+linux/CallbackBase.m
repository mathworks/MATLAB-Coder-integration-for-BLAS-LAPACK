classdef CallbackBase
    properties(Constant)
        LibPath = utils.setOpenBLASPath('/opt/OpenBLAS/lib', 'lib')
        IncludePath = utils.setOpenBLASPath('/opt/OpenBLAS/include', 'include')
        % For OpenBLAS installed using Debian/Ubuntu apt use the following
        % However, the installed version does not come with LAPACKE and cannot be used
        % with MATLAB coder for LAPACK callback classes
        % LibPath = '/usr/lib/x86_64-linux-gnu/openblas-openmp'
        % IncludePath = '/usr/include/x86_64-linux-gnu/openblas-openmp'

        MainLib = 'openblas'
        OtherLibs = {'gfortran', 'pthread'}
        % Assumes use of gcc and GNU omp to link
        StaticLib = {'gomp'}
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
                    assert(isunix, 'The BLAS/LAPACK callback class currently specified in the code generation configuration is intended for Linux only. Please use the appropriate class for your operating system');

                    % Error if library path does not exist
                    libPath = openBLAS.linux.CallbackBase.LibPath;
                    assert(exist(libPath, "dir"),...
                        'The library directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', libPath);

                    % Error if include path does not exist
                    incPath = openBLAS.linux.CallbackBase.IncludePath;
                    assert(exist(incPath, "dir"),...
                        'The include directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OpenBLAS library', incPath);
                end
            end

            if strcmp(ctx.getTargetLang, 'C++')
                % The -Wno-pedantic flag may be required to get some versions of OpenBLAS work with MATLAB
                % coder when generating C++ code. Uncomment the next line when required.
                % buildInfo.addCompileFlags('-Wno-pedantic');
                buildInfo.addCompileFlags('-Dlapack_complex_float="std::complex<float>"');
                buildInfo.addCompileFlags('-Dlapack_complex_double="std::complex<double>"');
            end
            % For include lapackeWrapper.h
            buildInfo.addIncludePaths(fileparts(mfilename("fullpath")));

            if isStatic
                libName = append('lib', openBLAS.linux.CallbackBase.MainLib);
                libPriority = '';
                libPreCompiled = true;
                libLinkOnly = true;
                buildInfo.addLinkObjects(libName, openBLAS.linux.CallbackBase.LibPath,...
                   libPriority , libPreCompiled, libLinkOnly);
                % Assumes use of gcc
                buildInfo.addSysLibs(openBLAS.linux.CallbackBase.StaticLib);
            else
                buildInfo.addLinkFlags(['-Wl,-rpath,' openBLAS.linux.CallbackBase.LibPath]);
                buildInfo.addLinkFlags('-Wl,--no-as-needed');
                buildInfo.addLinkFlags(['-L' openBLAS.linux.CallbackBase.LibPath]);
                buildInfo.addSysLibs(openBLAS.linux.CallbackBase.MainLib);
            end

            if ~isempty(openBLAS.linux.CallbackBase.OtherLibs)
                buildInfo.addSysLibs(openBLAS.linux.CallbackBase.OtherLibs);
            end

            buildInfo.addIncludePaths(openBLAS.linux.CallbackBase.IncludePath);
        end
    end
end
