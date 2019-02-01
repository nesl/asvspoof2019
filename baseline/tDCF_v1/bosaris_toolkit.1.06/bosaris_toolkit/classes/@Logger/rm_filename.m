function rm_filename(logger,fname)
% Stops the logger writing to the named file and closes the file.
% Inputs:
%   fname: The name of the (open) log file.

f = find(ismember(logger.filenamelist,fname)==1);
if isempty(f)
    fprintf('Warning: filename "%s" is not in the list and can not be removed.\n',fname);
else
    fid = logger.filenamefids(f);
    fclose(fid);
    logger.filenamelist(f) = [];
    logger.filenamefids(f) = [];
    logger.filenamelevels(f) = [];
end   

assert(logger.validate())
