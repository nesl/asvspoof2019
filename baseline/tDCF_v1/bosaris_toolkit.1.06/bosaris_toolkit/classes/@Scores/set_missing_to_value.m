function new_scr = set_missing_to_value(scr,ndx,value)
% Sets all scores for which the trialmask is true but the scoremask
% is false to the same value, supplied by the user.
% Inputs:
%   scr: A Scores object.
%   ndx: A Key or Ndx object.
%   value: A value for the missing scores.
% Outputs:
%   new_scr: A Scores object (with the missing scores added and set
%     to value).

assert(nargin==3)
assert(isa(scr,'Scores'))
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))
assert(scr.validate())
assert(ndx.validate())

if isa(ndx,'Key')
    ndx = ndx.to_ndx();
end

new_scr = scr.align_with_ndx(ndx);
missing = ndx.trialmask & ~new_scr.scoremask;
new_scr.scoremat(missing) = value;
new_scr.scoremask(missing) = true;

assert(new_scr.validate())
