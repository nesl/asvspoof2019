function rm_stdout(logger)
% Stops the logger writing to the standard output.

f = find(logger.fidlist==1);
if isempty(f)
    fprintf('Warning: stdin is not in the list and can not be removed.\n');
else
    logger.fidlist(f) = [];
    logger.fidlevels(f) = [];    
end  

assert(logger.validate())
