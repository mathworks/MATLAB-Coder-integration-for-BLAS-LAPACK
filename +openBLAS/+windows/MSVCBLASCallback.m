classdef MSVCBLASCallback < coder.BLASCallback & openBLAS.windows.MSVCCallbackBase
    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'blasint';
        end
    end
end
