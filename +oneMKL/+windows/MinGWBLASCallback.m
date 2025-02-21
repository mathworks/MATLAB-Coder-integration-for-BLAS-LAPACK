classdef MinGWBLASCallback < coder.BLASCallback & oneMKL.windows.MinGWCallbackBase

    methods(Static)
        
        function headerName = getHeaderFilename()
            headerName = 'mkl_cblas.h';
        end

        function intTypeName = getBLASIntTypeName()
            intTypeName = 'MKL_INT';
        end

    end

end
