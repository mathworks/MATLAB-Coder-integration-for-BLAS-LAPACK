classdef OpenMPBLASCallback < coder.BLASCallback & oneMKL.windows.MSVCCallbackBase

    properties(Constant)
        LibName = {'mkl_intel_thread'}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'MKL_INT';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.windows.MSVCCallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.windows.OpenMPBLASCallback.LibName);
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
