function [dev_lin,eval_lin,dev_qual,eval_qual] = linear_and_quality_fusion_dev_eval(key_dev,dev_scores_obj_array,dev_qual_obj_array,Qtrans,...
                                                  ndx_eval,eval_scores_obj_array,eval_qual_obj_array,...
                                                  prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion on the dev scores which it applies
% (separately) to the dev scores and eval scores.  It then trains a
% fusion of the dev scores with dev quality measures which it
% applies (separately) to the dev scores (with the dev quality
% measures) and eval scores (with the eval quality measures).  The
% inputs must already be loaded.  Use
% 'linear_and_quality_fusion_dev_eval_from_files' if you want the script to do
% loading and saving for you.
% Inputs:
%   key_dev: The Key containing information about the dev trials.
%   dev_scores_obj_array: An array of Scores objects containing
%     system scores for the dev trials.
%   dev_qual_obj_array: An array of Quality objects containing
%     quality measures for the dev segments.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is. 
%   ndx_eval: The Ndx describing the eval trials.
%   eval_scores_obj_array: An array of Scores objects containing
%     system scores for the eval trials.
%   eval_qual_obj_array: An array of Quality objects containing
%     quality measures for the eval segments.
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
%   dev_lin: The dev scores resulting from the linear fusion.
%   eval_lin: The eval scores resulting from the linear fusion.
%   dev_qual: The dev scores resulting from the quality fusion.
%   eval_qual: The eval scores resulting from the quality fusion.

assert(nargin==12)
assert(isa(key_dev,'Key'))
assert(isa(ndx_eval,'Ndx'))

logprint(Logger.Info,'training linear fuser\n')
[flin,wlin] = train_linear_fusion_function(key_dev,dev_scores_obj_array,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'linear fusing dev scores\n')
dev_lin = apply_linear_fusion_function(key_dev,dev_scores_obj_array,flin);

logprint(Logger.Info,'linear fusing eval scores\n')
eval_lin = apply_linear_fusion_function(ndx_eval,eval_scores_obj_array,flin);

logprint(Logger.Info,'training quality fuser\n')
fqual = train_quality_fusion_function(key_dev,dev_scores_obj_array,dev_qual_obj_array,Qtrans,wlin,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'quality fusing dev scores\n')
dev_qual = apply_quality_fusion_function(key_dev,dev_scores_obj_array,dev_qual_obj_array,Qtrans,fqual,dev_lin);

logprint(Logger.Info,'quality fusing eval scores\n')
eval_qual = apply_quality_fusion_function(ndx_eval,eval_scores_obj_array,eval_qual_obj_array,Qtrans,fqual,eval_lin);

end
