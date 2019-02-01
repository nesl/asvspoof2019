function ok = validate(scr)
% Checks that an object of type Scores obeys certain rules that
% must always be true.
% Inputs:
%   scr: the object to be checked.
% Outputs:
%   ok: a boolean value indicating whether the object is valid.

assert(nargin==1)
assert(isa(scr,'Scores'))

ok = iscell(scr.modelset);
ok = ok && iscell(scr.segset);

nummods = length(scr.modelset);
numsegs = length(scr.segset);

ok = ok && (size(scr.scoremask,1)==nummods);
ok = ok && (size(scr.scoremask,2)==numsegs);

ok = ok && (size(scr.scoremat,1)==nummods);
ok = ok && (size(scr.scoremat,2)==numsegs);
