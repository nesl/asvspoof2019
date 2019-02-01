function log_error(str,varargin)
% Sends its inputs to the logger if it exists; otherwise does
% nothing.  The logging level is set to Error.
% Inputs:
%   str: A string (possibly containing format specifiers).
%   varargin: An optional parameter list of values for the format
%     specifiers in the string.
% See documentation for fprintf for a description of the
% parameters 'str' and 'varargin'.

assert(isa(str,'char'))

outstr = ['Error: ',str];

logprint(Logger.Error,outstr,varargin{:});
