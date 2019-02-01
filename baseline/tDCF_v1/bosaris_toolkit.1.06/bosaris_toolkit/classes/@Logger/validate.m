function ok = validate(logger)
% Checks that an object of type Logger obeys certain rules that
% must always be true.
% Inputs:
%   logger: the object to be checked.
% Outputs:
%   ok: a boolean value indicating whether the object is valid.

assert(nargin==1)
assert(isa(logger,'Logger'))

ok = length(logger.fidlist)==length(logger.fidlevels);
ok = ok && length(logger.filenamelist)==length(logger.filenamefids);
ok = ok && length(logger.filenamelist)==length(logger.filenamelevels);
ok = ok && all(logger.fidlist > 0);
ok = ok && all(logger.filenamefids > 0);
ok = ok && all(logger.fidlevels >= 0);
ok = ok && all(logger.fidlevels < 256);
ok = ok && all(logger.filenamelevels >= 0);
ok = ok && all(logger.filenamelevels < 256);
