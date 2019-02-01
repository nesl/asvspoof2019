function fusion = qfuser_backoff(w,scores,scrQ,ndx,backoff_scores)
% A wrapper around qfuser_linear that substitutes backoff scores
% for any trials that are missing scores from the quality fuser.
% The backoff scores will typically be the scores from the
% non-quality fusion.
% Inputs:
%   w: The trained quality fusion weights.
%   scores: The system scores.
%   scrQ: The quality measures.
%   ndx: A Key or Ndx object indicating trials.
%   backoff_scores: A vector of scores to use if missing from
%     quality fusion output.
% Outputs:
%   fusion: A vector of scores; one for each trial.  Scores will be
%     from quality fusion unless they are missing in which case
%     they will be copied over from backoff_scores.

assert(isa(scrQ,'Quality'))
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))
assert(isvector(backoff_scores))

if isa(ndx,'Ndx')
    trials = ndx.trialmask;
else
    trials = ndx.tar | ndx.non;
end

[m,n] = size(scores);
assert(n==sum(trials(:)));

% Get fused scores from quality fuser.
fusion = qfuser_linear(w,scores,scrQ,ndx);

% Check for missing scores.
assert(all(size(trials)==size(scrQ.scoremask)));
missing = trials & ~scrQ.scoremask;
missing = missing(trials(:));
nmiss = sum(missing(:));

% Use backoff scores for missing scores.
if nmiss > 0
    log_warning('Quality missing for %i of %i trials, substituting backoff scores.\n',nmiss,n);
    fusion(missing) = backoff_scores(missing);
end

end
