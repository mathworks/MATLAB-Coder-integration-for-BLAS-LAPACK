classdef SequentialBLASCallback < coder.BLASCallback & oneMKL.linux.CallbackBase

    properties(Constant)
        LibName = {'mkl_sequential'}
        OtherLibs = {}
    end

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'mkl_cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'MKL_INT';
        end

        function updateBuildInfo(buildInfo, ctx)
            oneMKL.linux.CallbackBase.updateBuildInfoHelper(buildInfo, ctx, ...
                oneMKL.linux.SequentialBLASCallback.LibName,...
                oneMKL.linux.SequentialBLASCallback.OtherLibs);
        end
    end

end
