function out = setOneAPIPath(defaultPath)
    currentPath = fileparts(mfilename('fullpath'));
    repoPath = fileparts(currentPath);

    pathFile = 'paths.json';
    pathFileFullPath = fullfile(repoPath, pathFile);
    pathFileExists = isfile(pathFileFullPath);

    useDefault = true;

    if pathFileExists
        pathStr = fileread(pathFileFullPath);
        settings = jsondecode(pathStr);
        if isfield(settings, 'OneAPIPath')
            out = settings.OneAPIPath;
            useDefault = false;
        end
    end

    % If path is not available in json file set it here
    if useDefault
        % Check if ONEAPI_ROOT variable is set in env
        oneAPIPath = getenv('ONEAPI_ROOT');
        if isempty(oneAPIPath)
            % Check if MKLROOT variable is set in env, if so use it
            mklPath = getenv('MKLROOT');
            if isempty(mklPath)
                % Set default PATH if MKLROOT env path is not found
                out = defaultPath;
            else
                % USe MKLROOT variable and set the path
                out = fileparts(fileparts(mklPath));
            end
        else
            out = oneAPIPath;
        end
    end

end
