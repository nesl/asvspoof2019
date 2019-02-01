function fqual = train_quality_fusion_function(key,scores_obj_array,qual_obj_array,Qtrans,wlin,prior,obj_func,niters,cstepHessian,quiet)
% Trains a quality fusion function from a set of scores, a set of
% quality measures and a key.
% Inputs:
%   key: A Key object describing the scores.
%   scores_obj_array: An array of score objects (one object for
%     each system) to be fused.
%   qual_obj_array: An array of quality measure objects.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is. 
%   wlin: A vector containing the fusion weights for the trained
%     linear fusion.
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
%   fqual: A function handle to the trained quality fusion function.

stacked_scores = stackScores(key,scores_obj_array);
stackedQ = stackQ(key,qual_obj_array);
scrQ = applyQtrans(stackedQ,Qtrans);
fqual = train_qfuser(stacked_scores,scrQ,key,quiet,wlin,cstepHessian,niters,obj_func,prior);
end
