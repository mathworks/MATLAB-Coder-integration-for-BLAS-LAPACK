classdef MSVCLAPACKCallback < coder.LAPACKCallback & openBLAS.windows.MSVCCallbackBase
    methods (Static)
        function headerName = getHeaderFilename()
            headerName = 'lapacke.h';
        end
    end
end
