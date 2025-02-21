classdef MinGWLAPACKCallback < coder.LAPACKCallback & openBLAS.windows.MinGWCallbackBase
    methods (Static)
        function headerName = getHeaderFilename()
            headerName = 'lapacke.h';
        end
    end
end