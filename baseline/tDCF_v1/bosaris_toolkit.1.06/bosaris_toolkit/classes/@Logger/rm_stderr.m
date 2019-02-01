function rm_stderr(logger)
% Stops the logger writing to standard error.

f = find(logger.fidlist==2);
if isempty(f)
    fprintf('Warning: stderr is not in the list and can not be removed.\n');
else
    logger.fidlist(f) = [];
    logger.fidlevels(f) = [];
end  

assert(logger.validate())
