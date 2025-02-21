classdef MinGWBLASCallback < coder.BLASCallback & openBLAS.windows.MinGWCallbackBase
    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'blasint';
        end
    end
end
