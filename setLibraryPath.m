function setLibraryPath(options)
    arguments
        options.OneAPIPath (1, :) char
        options.OpenBLASPath (1, :) char
        options.OpenBLASIncludePath (1, :) char
        options.OpenBLASLibPath (1, :) char
    end
    
    narginchk(2, 8);

    pathFile = 'paths.json';
    repoPath = fileparts(mfilename('fullpath'));
    pathFileFullPath = fullfile(repoPath, pathFile);
    pathFileExists = isfile(pathFileFullPath);

    if pathFileExists
        pathStr = fileread(pathFileFullPath);
        settings = jsondecode(pathStr);
    else
        settings = struct();
    end

    allVars = {'OneAPIPath', 'OpenBLASPath', 'OpenBLASLibPath', 'OpenBLASIncludePath'};
    for ii = 1:numel(allVars)
        settings = updateFieldIfNotEmpty(options, allVars{ii}, settings);
    end

    outStr = jsonencode(settings, PrettyPrint=true);
    fid = fopen(pathFileFullPath, 'w');
    fprintf(fid, '%s', outStr);
    fclose(fid);
end

function out = updateFieldIfNotEmpty(options, field, settings)
    if isfield(options, field)
        if isempty(options.(field))
            if isfield(settings, field)
                settings = rmfield(settings, field);
            end
        else
            settings.(field) = options.(field);
        end
    end
    out = settings;
end

