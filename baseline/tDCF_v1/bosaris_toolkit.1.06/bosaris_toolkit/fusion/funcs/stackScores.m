function scores = stackScores(ndx,score_obj_array)
% Places the scores for all the systems in the array into a single
% matrix.  All systems must have scores for all trials (the
% calibration code adds zeros for missing scores after calibrating
% the scores).
% Inputs:
%   ndx: A Key or Ndx object indicating trials.
%   score_obj_array: An array of Scores objects; one for each system.
% Outputs:
%   scores: A number-of-systems by number-of-trials matrix of scores.

assert(nargin==2)
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))

if isa(ndx,'Ndx')
    trials = ndx.trialmask(:)';
else
    trials = ndx.tar(:)' | ndx.non(:)';
end
numtrials = sum(trials);
numsystems = length(score_obj_array);
scores = zeros(numsystems,numtrials);

for ii=1:numsystems
    scr = score_obj_array(ii).align_with_ndx(ndx);
    assert(sum(scr.scoremask(:))==numtrials)
    scores(ii,:) = scr.scoremat(trials);
end
                     
end
