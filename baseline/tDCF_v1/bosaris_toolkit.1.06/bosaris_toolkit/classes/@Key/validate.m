function ok = validate(key)
% Checks that an object of type Key obeys certain rules that
% must always be true.
% Inputs:
%   key: the object to be checked.
% Outputs:
%   ok: a boolean value indicating whether the object is valid.

assert(nargin==1)
assert(isa(key,'Key'))

ok = iscell(key.modelset);
ok = ok && iscell(key.segset);

nummods = length(key.modelset);
numsegs = length(key.segset);

ok = ok && (size(key.tar,1)==nummods);
ok = ok && (size(key.tar,2)==numsegs);

ok = ok && (size(key.non,1)==nummods);
ok = ok && (size(key.non,2)==numsegs);

