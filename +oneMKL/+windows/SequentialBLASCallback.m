classdef SequentialBLASCallback < coder.BLASCallback & oneMKL.windows.MSVCCallbackBase

    properties(Constant)
        LibName = {'mkl_sequential'}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'MKL_INT';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.windows.MSVCCallbackBase.updateBuildInfoHelper(buildInfo, ctx,...
                oneMKL.windows.SequentialBLASCallback.LibName);
        end
    end

end
