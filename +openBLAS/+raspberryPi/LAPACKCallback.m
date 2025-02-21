classdef LAPACKCallback < coder.LAPACKCallback & openBLAS.raspberryPi.CallbackBase

    methods(Static)
        function headerName = getHeaderFilename()
            headerName = 'lapackeWrapper.h';
        end
    end

end
