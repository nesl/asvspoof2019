function add_stdout(logger,level)
% After a call to this method, log messages with the appropriate
% level setting will be written to standard out (as well as other
% log files).
% Inputs:
%   level: Indicates which log messages should go to standard out.
%     See the class definition file for a list of levels.  Levels
%     can be combined by bit oring them.

if ~isempty(find(logger.fidlist==1))
    fprintf('Warning: stdin is already in the list and will not be added.\n');
else
    logger.fidlist = [logger.fidlist, 1];
    if ~exist('level','var')
	level = Logger.All;
    else
	assert(level >= 0)
    end
    logger.fidlevels = [logger.fidlevels, level];
end  

assert(logger.validate())
