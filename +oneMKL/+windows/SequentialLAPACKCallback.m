classdef SequentialLAPACKCallback < coder.LAPACKCallback & oneMKL.windows.MSVCCallbackBase

    properties(Constant)
        LibName = {'mkl_sequential'}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_lapacke.h';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.windows.MSVCCallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.windows.SequentialLAPACKCallback.LibName);
        end
    end

end
