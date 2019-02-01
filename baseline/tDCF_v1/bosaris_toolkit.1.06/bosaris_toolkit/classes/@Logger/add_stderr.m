function add_stderr(logger,level)
% After a call to this method, log messages with the appropriate
% level setting will be written to standard error (as well as other
% log files).
% Inputs:
%   level: Indicates which log messages should go to standard error.
%     See the class definition file for a list of levels.  Levels
%     can be combined by bit oring them.

if ~isempty(find(logger.fidlist==2))
    fprintf('Warning: stderr is already in the list and will not be added.\n');
else
    logger.fidlist = [logger.fidlist, 2];
    if ~exist('level','var')
	level = Logger.All;
    else
	assert(level >= 0)
    end
    logger.fidlevels = [logger.fidlevels, level];
end

assert(logger.validate())
