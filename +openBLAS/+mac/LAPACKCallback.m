classdef LAPACKCallback < coder.LAPACKCallback & openBLAS.mac.CallbackBase

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'lapacke.h';
        end
    end

end
