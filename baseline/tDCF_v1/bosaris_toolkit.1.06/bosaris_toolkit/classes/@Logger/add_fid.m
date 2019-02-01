function add_fid(logger,fid,level)
% After a call to this method, log messages with the appropriate
% level setting will be written to this file (as well as other
% log files).  This method expects an already open file.  The file
% must be closed by code outside this class after it is removed
% from the logger. 
% Inputs:
%   fid: A file handle for the log file.
%   level: Indicates which log messages should go to this log file.
%     See the class definition file for a list of levels.  Levels
%     can be combined by bit oring them.

if ~isempty(find(logger.fidlist==fid))
    fprintf('Warning: fid: %d is already in the list and will not be added.\n',fid);
else
    logger.fidlist = [logger.fidlist, fid];
    if ~exist('level','var')
	level = Logger.All;
    else
	assert(level >= 0)
    end
    logger.fidlevels = [logger.fidlevels, level];
end

assert(logger.validate())
