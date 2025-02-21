classdef (Abstract) CallbackBase
    properties(Constant)
        InstallPath = utils.setOneAPIPath('/opt/intel/oneapi')

        LibNamesCommon = {'mkl_intel_lp64', 'mkl_core'}
        OtherLibsCommon = {'pthread', 'm', 'dl'}
    end

    properties(Constant, Abstract)
        LibNames
        OtherLibs
    end

    methods (Static)
        function updateBuildInfoHelper(buildInfo, ctx, libNames, otherLibs)
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet') && strcmp(ctx.ConfigData.OutputType, 'LIB')
                isStatic = true;
            else
                % Branch for dll and exe
                % Simulink code will be linked dynamically
                isStatic = false;
            end

            MKLRoot = fullfile(oneMKL.linux.CallbackBase.InstallPath, 'mkl', 'latest');
            MKLRootLib = fullfile(MKLRoot, 'lib');
            incPath = fullfile(MKLRoot, 'include');
            % Check if the target is not PIL or the generate code only
            % setting is on for non-simulink configurations
            if ~isa(ctx.ConfigData, 'Simulink.ConfigSet')
                if ~ctx.ConfigData.GenCodeOnly && ~strcmp(ctx.ConfigData.VerificationMode, 'PIL')
                    % Error if callback used is not on Windows
                    assert(isunix, 'The BLAS/LAPACK callback class currently specified in the code generation configuration is intended for Linux only. Please use the appropriate class for your operating system');

                    % Error if library path does not exist
                    assert(exist(MKLRootLib, "dir"),...
                        'The library directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OneAPI library', MKLRootLib);

                    % Error if include path does not exist
                    assert(exist(incPath, "dir"),...
                        'The include directory "%s" does not exist. Please refer to the README file on how to set the installation path to the OneAPI library', incPath);
                end
            end

            allLibs = [oneMKL.linux.CallbackBase.LibNamesCommon, libNames];

            if isStatic
                libName = append('lib', allLibs);
                buildInfo.addLinkObjects(libName, MKLRootLib, '', true, true);
            else
                buildInfo.addLinkFlags(['-m64 -Wl,-rpath,' MKLRootLib]);
                buildInfo.addLinkFlags('-Wl,--no-as-needed');
                buildInfo.addLinkFlags(['-L' MKLRootLib]);
                buildInfo.addSysLibs(allLibs);
            end

            if ~isempty(otherLibs)
                libName = [oneMKL.linux.CallbackBase.OtherLibsCommon, otherLibs];
            else
                libName = oneMKL.linux.CallbackBase.OtherLibsCommon;
            end
            buildInfo.addSysLibs(libName);
            buildInfo.addIncludePaths(incPath);
        end
    end
end
