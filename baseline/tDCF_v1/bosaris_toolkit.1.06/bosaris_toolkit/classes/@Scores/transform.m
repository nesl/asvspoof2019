function new_scr = transform(scr,func)
% Transforms the scores by sending them through the given function.
% Inputs:
%   scr: A Scores object.
%   func: A function handle of the function to apply to the scores.
% Outputs:
%   new_scr: A Scores object containing the transformed scores.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(func,'function_handle'))
assert(scr.validate())

new_scr = scr;
hasscores = scr.scoremask(:)';
new_scr.scoremat(hasscores) = func(scr.scoremat(hasscores));

assert(new_scr.validate())
