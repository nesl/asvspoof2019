function logprint(level,str,varargin)
% Sends its inputs to the logger if it exists; otherwise does nothing.
% Inputs:
%   level: The logging level.  The higher this number, the more
%     files it will be written to.  If it is zero, the string will
%     not be logged.
%   str: A string (possibly containing format specifiers).
%   varargin: An optional parameter list of values for the format
%     specifiers in the string.
% See documentation for fprintf for a description of the
% parameters 'str' and 'varargin'.

global logger

assert(isa(str,'char'))
assert(level>=0)

if exist('logger','var') && ~isempty(logger)
    logger.log(level,str,varargin{:});
end
