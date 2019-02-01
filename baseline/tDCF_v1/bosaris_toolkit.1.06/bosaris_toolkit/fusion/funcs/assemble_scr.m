function scr = assemble_scr(scores,ndx)
% Takes a vector of scores and produces a Scores object.
% Inputs:
%   scores: An array of scores.
%   ndx: An object of type Key or Ndx.  Information describing the
%     scores is extracted from this object.
% Outputs:
%   scr: An object of type Scores containing the scores in
%     'scores'. 

if isa(ndx,'Ndx')
    trialmask = ndx.trialmask;
else
    trialmask = ndx.tar | ndx.non;
end
scr = Scores();
scr.scoremat = zeros(size(trialmask));
scr.scoremat(trialmask(:)) = scores;
scr.scoremask = trialmask;
scr.modelset = ndx.modelset;
scr.segset = ndx.segset;
end
