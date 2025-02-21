classdef SequentialLAPACKCallback < coder.LAPACKCallback & oneMKL.linux.CallbackBase

    properties(Constant)
        LibName = {'mkl_sequential'}
        OtherLibs = {}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_lapacke.h';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.linux.CallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.linux.SequentialLAPACKCallback.LibName,...
                oneMKL.linux.SequentialLAPACKCallback.OtherLibs);
        end
    end

end
