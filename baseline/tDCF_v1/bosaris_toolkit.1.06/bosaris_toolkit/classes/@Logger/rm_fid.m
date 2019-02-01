function rm_fid(logger,fid)
% Stops the logger writing to the given file.  The file is not
% closed (that is the responsibility of the user code).
% Inputs:
%   fid: A file id of an open log file.

f = find(logger.fidlist==fid);
if isempty(f)
    fprintf('Warning: fid: %d is not in the list and can not be removed.\n',fid);
else
    logger.fidlist(f) = [];
    logger.fidlevels(f) = [];
end  

assert(logger.validate())
