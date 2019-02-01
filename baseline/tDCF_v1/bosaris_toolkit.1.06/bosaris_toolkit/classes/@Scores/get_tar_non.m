function [tar,non] = get_tar_non(scr,key)
% Divides scores into target and non-target scores using
% information in a key.
% Inputs:
%   scr: A Scores object.
%   key: A Key object.
% Outputs:
%   tar: A vector of target scores.
%   non: A vector of non-target scores.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(key,'Key'))
assert(scr.validate())
assert(key.validate())

scr = scr.align_with_ndx(key);
scores = scr.scoremat;
tarndx = key.tar & scr.scoremask;
nonndx = key.non & scr.scoremask;
tar = scores(tarndx(:))';
non = scores(nonndx(:))';
end
