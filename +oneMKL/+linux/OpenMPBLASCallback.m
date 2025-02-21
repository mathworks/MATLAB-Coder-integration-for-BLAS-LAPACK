classdef OpenMPBLASCallback < coder.BLASCallback & oneMKL.linux.CallbackBase

    properties(Constant)
        LibName = {'mkl_intel_thread'}
        OtherLibs = {'iomp5'}
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
                oneMKL.linux.OpenMPBLASCallback.LibName,...
                oneMKL.linux.OpenMPBLASCallback.OtherLibs);
            % Add intel openMP library location
            buildInfo.addLinkFlags(['-L' fullfile(oneMKL.linux.CallbackBase.InstallPath,...
                'compiler', 'latest', 'lib')]);
        end
    end

end
