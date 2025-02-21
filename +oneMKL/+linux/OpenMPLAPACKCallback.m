classdef OpenMPLAPACKCallback < coder.LAPACKCallback & oneMKL.linux.CallbackBase

    properties(Constant)
        LibName = {'mkl_intel_thread'}
        OtherLibs = {'iomp5'}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_lapacke.h';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.linux.CallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.linux.OpenMPLAPACKCallback.LibName,...
                oneMKL.linux.OpenMPLAPACKCallback.OtherLibs);
            % Add intel openMP library location
            buildInfo.addLinkFlags(['-L' fullfile(oneMKL.linux.CallbackBase.InstallPath,...
                'compiler', 'latest', 'lib')]);
        end
    end

end
