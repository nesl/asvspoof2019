function [actdcf,mindcf,prbep,eer] = fastEval(tar,non,prior)
% Calculates actual dcf, min dcf and prbeb values. 
% Inputs:
%   tar: A vector of target scores.
%   non: A vector of non-target scores.
%   prior: The effective target prior (or a vector of priors).
% Outputs:
%   actdcf: The actual dcf value (or a vector if the prior is a vector).
%   mindcf: The minimum dcf value (or a vector if the prior is a vector).
%   prbep: Precision/Recall Break Even Point (#fa = #miss on ROCCH
%     curve). 
%   eer: Equal error rate.

assert(isvector(tar))
assert(isvector(non))
assert(isvector(prior))

actdcf = fast_actDCF(tar,non,logit(prior),true);
[mindcf,pmiss,pfa,prbep,eer] = fast_minDCF(tar,non,logit(prior),true);
