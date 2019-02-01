function [dev_lin,eval_lin] = linear_fusion_dev_eval(key_dev,dev_scores_obj_array,ndx_eval,eval_scores_obj_array,...
						     prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion on the dev scores which it applies
% (separately) to the dev scores and eval scores.  The inputs must
% already be loaded.  Use 'linear_fusion_dev_eval_from_files' if
% you want the script to do loading and saving for you.
% Inputs:
%   key_dev: The Key containing information about the dev trials.
%   dev_scores_obj_array: An array of Scores objects containing
%     system scores for the dev trials.
%   ndx_eval: The Ndx describing the eval trials.
%   eval_scores_obj_array: An array of Scores objects containing
%     system scores for the eval trials.
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

assert(nargin==9)
assert(isa(key_dev,'Key'))
assert(isa(ndx_eval,'Ndx'))

logprint(Logger.Info,'training linear fuser\n');
flin = train_linear_fusion_function(key_dev,dev_scores_obj_array,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'fusing dev scores\n');
dev_lin = apply_linear_fusion_function(key_dev,dev_scores_obj_array,flin);

logprint(Logger.Info,'fusing eval scores\n');
eval_lin = apply_linear_fusion_function(ndx_eval,eval_scores_obj_array,flin);
  
end
