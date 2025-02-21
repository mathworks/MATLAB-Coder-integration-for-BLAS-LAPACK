classdef LAPACKCallback < coder.LAPACKCallback & openBLAS.linux.CallbackBase

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'lapackeWrapper.h';
        end
    end

end
