function [scr_lin,scr_qual] = linear_and_quality_fusion_scores(key,scores_obj_array,qual_obj_array,Qtrans,...
                                                    prior,niters,obj_func,cstepHessian,quiet)
% Fuses scores (using linear fusion) and then fuses in quality
% measures.  The fusion is applied to the same scores as those used
% to train the fusion function.  The input scores and key must
% already be loaded.  Use 'linear_and_quality_fusion_scores_from_files' if you
% want the script to do loading and saving for you.
% Inputs:
%   key: The Key containing information about the trials.
%   scores_obj_array: An array of Scores objects containing
%     system scores for the trials.
%   qual_obj_array: An array of Quality objects containing
%     quality measures for the segments.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is. 
%   prior: The effective target prior.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.
% Outputs:
%   scr_lin: The scores resulting from the linear fusion.
%   scr_qual: The scores resulting from the quality fusion.

assert(nargin==9)
assert(isa(key,'Key'))
assert(~isempty(Qtrans))

logprint(Logger.Info,'training linear fuser\n')
[flin,wlin] = train_linear_fusion_function(key,scores_obj_array,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'linear fusing scores\n')
scr_lin = apply_linear_fusion_function(key,scores_obj_array,flin);

logprint(Logger.Info,'training quality fuser\n')
fqual = train_quality_fusion_function(key,scores_obj_array,qual_obj_array,Qtrans,wlin,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'quality fusing scores\n')
scr_qual = apply_quality_fusion_function(key,scores_obj_array,qual_obj_array,Qtrans,fqual,scr_lin);

end
