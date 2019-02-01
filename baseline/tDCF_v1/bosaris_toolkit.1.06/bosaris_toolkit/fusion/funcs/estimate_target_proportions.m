function props = estimate_target_proportions(scores,prior)
% Estimates the ratio of target trials (out of all trials).
% The posterior probability of a target is calculated for each
% trial.  Taking the mean of these posterior probabilities gives
% the expected number of targets.
% Inputs:
%   scores: An m-by-n matrix of llr scores where m is the number of
%     systems and n is the number of trials.
%   prior: The target prior (for the database).
% Outputs:
%   props: A vector of estimated target proportions; one for each
%     system. 

assert(nargin==2)
props = mean(sigmoid(scores+logit(prior)),2);
