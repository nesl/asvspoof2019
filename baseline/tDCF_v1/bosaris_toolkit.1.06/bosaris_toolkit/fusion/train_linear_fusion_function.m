function [flin,wlin] = train_linear_fusion_function(key,scores_obj_array,prior,obj_func,niters,cstepHessian,quiet)
% Trains a linear fusion function from a set of scores and a key.
% Inputs:
%   key: A Key object describing the scores.
%   scores_obj_array: An array of score objects (one object for
%     each system) to be fused.
%   prior: The effective target prior.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   niters: The maximum number of training iterations.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.
% Outputs:
%   flin: A function handle to the trained linear fusion function.
%   wlin: A vector containing the fusion weights.

stacked_scores = stackScores(key,scores_obj_array);
classf = make_classf_from_key(key);
[flin,nxe_train,wlin] = train_linear_fuser(stacked_scores,classf,prior,cstepHessian,quiet,niters,obj_func);
