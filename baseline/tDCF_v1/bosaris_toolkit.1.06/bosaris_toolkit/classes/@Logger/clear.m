function clear(logger)
% Removes all logfiles from the list.  Files that were added using
% their name (i.e. not their fid) are closed.

logger.fidlist = [];
logger.fidlevels = [];
for ii=1:length(logger.filenamefids)
    fclose(logger.filenamefids(ii));
end
logger.filenamelist = {};
logger.filenamefids = [];
logger.filenamelevels = [];

assert(logger.validate())
