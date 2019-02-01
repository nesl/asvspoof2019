function linear_fusion_scores_from_files(keyfilename,scorefilenames,outfilename,...
					 prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion function on a set of scores and then
% applies the fusion function to the same scores.  This script
% loads the key and scores and saves the fused scores.  It calls
% 'linear_fusion_scores' which works with alreay loaded objects.
% Inputs:
%   keyfilename: The name of the file containing the Key for the trials.
%   scorefilenames: A list of names of files containing the Scores
%     for the trials.
%   outfilename: The name of the output file for the scores
%     resulting from the linear fusion of the scores of the subsystems.
%   prior: The effective target prior.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.

assert(nargin==8)
assert(isa(keyfilename,'char'))
assert(iscell(scorefilenames))
assert(isa(outfilename,'char'))

key = Key.read(keyfilename);
scores_obj_array = load_score_files(scorefilenames);
fused_scr = linear_fusion_scores(key,scores_obj_array,prior,niters,obj_func,cstepHessian,quiet);
fused_scr.save(outfilename);
  
end
