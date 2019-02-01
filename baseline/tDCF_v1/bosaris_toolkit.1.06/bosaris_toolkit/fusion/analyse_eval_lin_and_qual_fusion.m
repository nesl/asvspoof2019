function analyse_eval_lin_and_qual_fusion(key_dev,ndx_eval,dev_scores_obj_array,eval_scores_obj_array,dev_scr_lin,eval_scr_lin,dev_scr_qual,eval_scr_qual)
% Does some analyses on evaluation scores for all systems and all
% fusions.  For each system, it calculates the estimated percentage
% of targets in the database.  It also calculates a KL divergence
% matrix of all systems against all systems.
% Inputs:
%   key_dev: The Key for the dev trials.
%   ndx_eval: The Ndx describing the eval trials.
%   dev_scores_obj_array: An array of Scores objects containing
%     system scores for the dev trials.
%   eval_scores_obj_array: An array of Scores objects containing
%     system scores for the eval trials.
%   dev_scr_lin: The dev scores resulting from the linear fusion.
%   eval_scr_lin: The eval scores resulting from the linear fusion.
%   dev_scr_qual: The dev scores resulting from the quality fusion.
%   eval_scr_qual: The eval scores resulting from the quality fusion.

assert(nargin==8)
assert(isa(key_dev,'Key'))
assert(isa(ndx_eval,'Ndx'))
assert(isa(dev_scr_lin,'Scores'))
assert(isa(eval_scr_lin,'Scores'))
assert(isa(dev_scr_qual,'Scores'))
assert(isa(eval_scr_qual,'Scores'))
assert(key_dev.validate())
assert(ndx_eval.validate())
assert(dev_scr_lin.validate())
assert(eval_scr_lin.validate())
assert(dev_scr_qual.validate())
assert(eval_scr_qual.validate())

eval_stacked_scores = stackScores(ndx_eval,eval_scores_obj_array);
trialmask = ndx_eval.trialmask;
eval_lin_fusion = eval_scr_lin.scoremat(trialmask(:))';
eval_qfusion = eval_scr_qual.scoremat(trialmask(:))';
eval_scores = [eval_stacked_scores;eval_lin_fusion;eval_qfusion];  

ptar = estimate_target_proportions(eval_scores,0.08);
logprint(Logger.Info,'\nSystem Ptar estimates:\n');
logprint(Logger.Info,'%s',sprintfmatrix(100*ptar'));

ptar_best = ptar(end-1);

dev_stacked_scores = stackScores(key_dev,dev_scores_obj_array);
trialmask = key_dev.to_ndx().trialmask;
dev_lin_fusion = dev_scr_lin.scoremat(trialmask(:))';
dev_qfusion = dev_scr_qual.scoremat(trialmask(:))';
dev_scores = [dev_stacked_scores;dev_lin_fusion;dev_qfusion];  

devKL = 100*kldivergence_of_systems(dev_scores,ptar_best,key_dev);
evalKL = 100*kldivergence_of_systems(eval_scores,ptar_best);
logprint(Logger.Info,'\nDev score divergence:\n%s',sprintfmatrix(devKL));
logprint(Logger.Info,'\nEval score divergence:\n%s',sprintfmatrix(evalKL));
end
