function analyse_dev_lin_fusion(key,scores_obj_array,scr_lin,prior)
% Analyses the dev scores for all input systems and their fusion
% so that their relative strengths can be compared.  It calculates
% the percentage of target trials calculated by each system and the
% actual dcf, min dcf and prbep values for each system.
% Inputs:
%   key: The Key for the dev trials.
%   scores_obj_array: An array of score objects (one object for
%     each system) that was fused.
%   scr_lin: An object of type Scores containing the result of the
%     linear fusion.
%   prior: The effective target prior.

assert(nargin==4)
assert(isa(key,'Key'))
assert(key.validate())

stacked_scores = stackScores(key,scores_obj_array);
trialmask = key.to_ndx().trialmask;
dev_lin_fusion = scr_lin.scoremat(trialmask(:))';
dev_scores = [stacked_scores;dev_lin_fusion];  

true_prop = sum(key.tar(:))/(sum(key.tar(:))+sum(key.non(:)));
logprint(Logger.Info,'True Dev target proportion is %g%%. System estimates are:\n',100*true_prop);
logprint(Logger.Info,'%s',sprintfmatrix(100*estimate_target_proportions(dev_scores,true_prop)'));

numsystems = size(stacked_scores,1);
mf = size(dev_scores,1);
logprint(Logger.Info,'\n\nAnalysing Dev: %i subsystems and %i fusions:\n',numsystems,mf-numsystems);
E = evalAll(dev_scores,key,prior);
logprint(Logger.Info,'\nDev all: dcf*100, mindcf*100, prbep:\n%s',sprintfmatrix(E,1:mf));
end
