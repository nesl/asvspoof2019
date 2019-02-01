function ok = validate(ndx)
% Checks that an object of type Ndx obeys certain rules that
% must always be true.
% Inputs:
%   ndx: the object to be checked.
% Outputs:
%   ok: a boolean value indicating whether the object is valid.

assert(nargin==1)
assert(isa(ndx,'Ndx'))

ok = iscell(ndx.modelset);
ok = ok && iscell(ndx.segset);

nummods = length(ndx.modelset);
numsegs = length(ndx.segset);

ok = ok && (size(ndx.trialmask,1)==nummods);
ok = ok && (size(ndx.trialmask,2)==numsegs);

