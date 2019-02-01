function ok = validate(qual)
% Checks that an object of type Seg_Quality obeys certain rules
% that must always be true.
% Inputs:
%   qual: the object to be checked.
% Outputs:
%   ok: a boolean value indicating whether the object is valid.

assert(nargin==1)
assert(isa(qual,'Seg_Quality'))

ok = iscell(qual.ids);
ok = ok && (size(qual.values,2)==length(qual.ids));
