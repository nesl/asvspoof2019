function add_filename(logger,fname,level)
% After a call to this method, log messages with the appropriate
% level setting will be written to this file (as well as other
% log files).  This method first creates the file.  When the file
% is removed from the list, it is closed.
% Inputs:
%   fname: The name of a file to create and write log messages to.
%   level: Indicates which log messages should go to the named file.
%     See the class definition file for a list of levels.  Levels
%     can be combined by bit oring them.

if ~isempty(find(ismember(logger.filenamelist,fname)==1))
    fprintf('Warning: filename "%s" is already in the list and will not be added.\n',fname);
else
    logger.filenamelist = {logger.filenamelist{:}, fname};
    fid = fopen(fname,'w');
    logger.filenamefids = [logger.filenamefids, fid];
        if ~exist('level','var')
	level = Logger.All;
    else
	assert(level >= 0)
    end
    logger.filenamelevels = [logger.filenamelevels, level];
end     

assert(logger.validate())
