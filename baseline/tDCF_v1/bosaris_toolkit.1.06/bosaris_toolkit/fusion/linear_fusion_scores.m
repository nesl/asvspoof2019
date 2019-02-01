function scr_lin = linear_fusion_scores(key,scores_obj_array,...
					prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion function on a set of scores and then
% applies the fusion function to the same scores.  The input scores
% and key must already be loaded.  Use
% 'linear_fusion_scores_from_files' if you want the script to do
% loading and saving for you.
% Inputs:
%   key: The Key containing information about the trials.
%   scores_obj_array: An array of Scores objects containing
%     system scores for the trials.
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

assert(nargin==7)
assert(isa(key,'Key'))

logprint(Logger.Info,'training linear fuser\n');
flin = train_linear_fusion_function(key,scores_obj_array,prior,obj_func,niters,cstepHessian,quiet);

logprint(Logger.Info,'fusing scores\n');
scr_lin = apply_linear_fusion_function(key,scores_obj_array,flin);

end
