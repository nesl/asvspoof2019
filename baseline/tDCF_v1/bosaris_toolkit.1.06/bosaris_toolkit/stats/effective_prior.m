function p = effective_prior(p_targ,cmiss,cfa);
% p = EFFECTIVE_PRIOR(p_targ,cmiss,cfa)
% 
% This function adjusts a given prior probability of target p_targ, 
% to incorporate the effects of a cost of miss, cmiss, and a cost of false-alarm, cfa.
% In particular note:
%   EFFECTIVE_PRIOR(EFFECTIVE_PRIOR(p,cmiss,cfa),1,1) = EFFECTIVE_PRIOR(p,cfa,cmiss)
%
% The effective prior for the NIST SRE detection cost fuction, 
% with p_targ = 0.01, cmiss = 10, cfa = 1 is therefore:
%  EFFECTIVE_PRIOR(0.01,10,1) = 0.0917
%   

p = p_targ*cmiss / (p_targ*cmiss + (1 - p_targ)*cfa);
