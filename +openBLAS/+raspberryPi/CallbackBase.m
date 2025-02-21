classdef CallbackBase
    properties(Constant)
        LibPath = utils.setOpenBLASPath('/opt/OpenBLAS/lib', 'lib')
        IncludePath = utils.setOpenBLASPath('/opt/OpenBLAS/include', 'include')
        % For openblas installed using debian/ubuntu apt use the following
        % However, the installed version does not come with LAPACKE and cannot be used
        % with MATLAB coder for LAPACK callback classes
        % LibPath = '/usr/lib/aarch64-linux-gnu/openblas-openmp'
        % IncludePath = '/usr/include/aarch64-linux-gnu/openblas-openmp'

        MainLib = 'openblas'
        OtherLibs = {'gfortran', 'pthread'}
    end

    methods (Static)
        function updateBuildInfo(buildInfo, ctx)
            if strcmp(ctx.getTargetLang, 'C++')
                % The -Wno-pedantic flag may be required to get some versions of OpenBLAS work with MATLAB
                % coder when generating C++ code. Uncomment the next line when required.
                % buildInfo.addCompileFlags('-Wno-pedantic');
                buildInfo.addCompileFlags('-Dlapack_complex_float="std::complex<float>"');
                buildInfo.addCompileFlags('-Dlapack_complex_double="std::complex<double>"');
            end
            % For include lapackeWrapper.h
            buildInfo.addIncludePaths(fileparts(mfilename("fullpath")));

            buildInfo.addLinkFlags(['-Wl,-rpath,' openBLAS.raspberryPi.CallbackBase.LibPath]);
            buildInfo.addLinkFlags('-Wl,--no-as-needed');
            buildInfo.addLinkFlags(['-L' openBLAS.raspberryPi.CallbackBase.LibPath]);
            buildInfo.addLinkFlags(['-l' openBLAS.raspberryPi.CallbackBase.MainLib]);

            if ~isempty(openBLAS.raspberryPi.CallbackBase.OtherLibs)
                libList = append('-l', openBLAS.raspberryPi.CallbackBase.OtherLibs, ' ');
                buildInfo.addLinkFlags([libList{:}]);
            end

            buildInfo.addCompileFlags(['-I' openBLAS.raspberryPi.CallbackBase.IncludePath]);
        end
    end
end
