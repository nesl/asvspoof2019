function analyse_dev_lin_and_qual_fusion(key,scores_obj_array,scr_lin,scr_qual,prior)
% Analyses the dev scores for all input systems (including fusions)
% to so that there relative strength can be compared.  It
% calculates the percentage of target trials calculated by each
% system and the actual dcf, min dcf and prbep values for each
% system.
% Inputs:
%   key: The Key for the dev trials.
%   scores_obj_array: An array of score objects (one object for
%     each system) that was fused.
%   scr_lin: An object of type Scores containing the result of the
%     linear fusion.
%   scr_qual: An object of type Scores containing the result of the
%     quality fusion.
%   prior: The effective target prior.

assert(nargin==5)
assert(isa(key,'Key'))
assert(isa(scr_lin,'Scores'))
assert(isa(scr_qual,'Scores'))
assert(key.validate())
assert(scr_lin.validate())
assert(scr_qual.validate())

trialmask = key.to_ndx().trialmask;
dev_stacked_scores = stackScores(key,scores_obj_array);
dev_lin_fusion = scr_lin.scoremat(trialmask(:))';
dev_qfusion = scr_qual.scoremat(trialmask(:))';
dev_scores = [dev_stacked_scores;dev_lin_fusion;dev_qfusion];  

true_prop = sum(key.tar(:))/(sum(key.tar(:))+sum(key.non(:)));
logprint(Logger.Info,'True Dev target proportion is %g%%. System estimates are:\n',100*true_prop);
logprint(Logger.Info,'%s',sprintfmatrix(100*estimate_target_proportions(dev_scores,true_prop)'));

numsystems = size(dev_stacked_scores,1);
mf = size(dev_scores,1);
logprint(Logger.Info,'\n\nAnalysing Dev: %i subsystems and %i fusions:\n',numsystems,mf-numsystems);
E = evalAll(dev_scores,key,prior);
logprint(Logger.Info,'\nDev all: dcf*100, mindcf*100, prbep:\n%s',sprintfmatrix(E,1:mf));
end
