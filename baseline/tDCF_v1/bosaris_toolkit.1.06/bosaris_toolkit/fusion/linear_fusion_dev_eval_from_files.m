function linear_fusion_dev_eval_from_files(devkeyfilename,devscorefilenames,...
					   evalndxfilename,evalscorefilenames,...
					   dev_outfilename,eval_outfilename,...
					   prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion on the dev scores which it applies
% (separately) to the dev scores and eval scores.  This script
% loads the key and scores and saves the fused scores.  It calls
% 'linear_fusion_dev_eval' which works with alreay loaded objects.
% Inputs:
%   devkeyfilename: The name of the file containing the Key for the
%     dev trials.
%   devscorefilenames: A list of names of files containing the
%     Scores for the dev trials.
%   evalndxfilename: The name of the file contraining the Ndx for
%     the eval trials (i.e. the trialmask).
%   evalscorefilenames: A list of names of files containing the
%     Scores for the eval trials.
%   dev_outfilename: The name of the output file for the dev scores
%     resulting from the linear fusion of the dev scores of the subsystems.
%   eval_outfilename: The name of the output file for the
%     eval scores resulting from the linear fusion of the eval
%     scores of the subsystems.
%   prior: The effective target prior.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.

assert(nargin==11)
assert(isa(devkeyfilename,'char'))
assert(iscell(devscorefilenames))
assert(isa(evalndxfilename,'char'))
assert(iscell(evalscorefilenames))
assert(isa(dev_outfilename,'char'))
assert(isa(eval_outfilename,'char'))

key_dev = Key.read(devkeyfilename);
ndx_eval = Ndx.read(evalndxfilename);

dev_scores_obj_array = load_score_files(devscorefilenames);
eval_scores_obj_array = load_score_files(evalscorefilenames);

[fused_dev,fused_eval] = linear_fusion_dev_eval(key_dev,dev_scores_obj_array,...
						ndx_eval,eval_scores_obj_array,...
						prior,niters,obj_func,cstepHessian,quiet);

fused_dev.save(dev_outfilename);
fused_eval.save(eval_outfilename);
  
end
