classdef OpenMPLAPACKCallback < coder.LAPACKCallback & oneMKL.windows.MSVCCallbackBase

    properties(Constant)
        LibName = {'mkl_intel_thread'}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_lapacke.h';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.windows.MSVCCallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.windows.OpenMPLAPACKCallback.LibName);
           % Add intel openMP library from oneAPI installation
            libPriority = '';
            libPreCompiled = true;
            libLinkOnly = true;
            ompPath = fullfile(oneMKL.windows.MSVCCallbackBase.InstallPath,...
                'compiler', 'latest', 'lib');
            buildInfo.addLinkObjects('libiomp5md.lib', ompPath, ...
                libPriority, libPreCompiled, libLinkOnly);
        end
    end

end
