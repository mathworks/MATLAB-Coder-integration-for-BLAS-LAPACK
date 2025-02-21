classdef MinGWLAPACKCallback < coder.LAPACKCallback & oneMKL.windows.MinGWCallbackBase

    methods(Static)
        
        function headerName = getHeaderFilename()
            headerName = 'mkl_lapacke.h';
        end

    end

end
