function out = setOpenBLASPath(defaultPath, type)

    currentPath = fileparts(mfilename('fullpath'));
    repoPath = fileparts(currentPath);

    pathFile = 'paths.json';
    pathFileFullPath = fullfile(repoPath, pathFile);
    pathFileExists = isfile(pathFileFullPath);

    useDefault = true;

    if strcmp(type, 'full')
        if pathFileExists
            pathStr = fileread(pathFileFullPath);
            settings = jsondecode(pathStr);
            if isfield(settings, 'OpenBLASPath')
                out = settings.OpenBLASPath;
                useDefault = false;
            end
        end
        % If path is not available in json file set it here
        if useDefault
            % Check if OpenBLAS_HOME variable is set in env
            openBlasHome = getenv('OpenBLAS_HOME');
            if isempty(openBlasHome)
                % Set default PATH if OpenBLAS_HOME env path is not found
                out = defaultPath;
            else
                % USe OpenBLAS_HOME variable and set the path
                out = openBlasHome;
            end
        end
    end

    if strcmp(type, 'lib')
        if pathFileExists
            pathStr = fileread(pathFileFullPath);
            settings = jsondecode(pathStr);
            if isfield(settings, 'OpenBLASLibPath')
                out = settings.OpenBLASLibPath;
                useDefault = false;
            elseif isfield(settings, 'OpenBLASPath')
                out = fullfile(settings.OpenBLASPath, 'lib');
                useDefault = false;
            end
        end
        % If path is not available in json file set it here
        if useDefault
            % Check if OpenBLAS_HOME variable is set in env
            openBlasHome = getenv('OpenBLAS_HOME');
            if isempty(openBlasHome)
                % Set default PATH if OpenBLAS_HOME env path is not found
                out = defaultPath;
            else
                % Use OpenBLAS_HOME variable and set the path
                out = fullfile(openBlasHome, 'lib');
            end
        end
    end

    if strcmp(type, 'include')
        if pathFileExists
            pathStr = fileread(pathFileFullPath);
            settings = jsondecode(pathStr);
            if isfield(settings, 'OpenBLASIncludePath')
                out = settings.OpenBLASIncludePath;
                useDefault = false;
            elseif isfield(settings, 'OpenBLASPath')
                out = fullfile(settings.OpenBLASPath, 'include');
                useDefault = false;
            end
        end
        % If path is not available in json file set it here
        if useDefault
            % Check if OpenBLAS_HOME variable is set in env
            openBlasHome = getenv('OpenBLAS_HOME');
            if isempty(openBlasHome)
                % Set default PATH if OpenBLAS_HOME env path is not found
                out = defaultPath;
            else
                % USe OpenBLAS_HOME variable and set the path
                out = fullfile(openBlasHome, 'include');
            end
        end
    end

end
