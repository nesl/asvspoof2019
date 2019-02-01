function linear_and_quality_fusion_dev_eval_from_files(devkeyfilename,devscorefilenames,devQfilenames,Qtrans, ...
					    evalndxfilename,evalscorefilenames,evalQfilenames,...
					    dev_lin_outfilename,dev_qfuse_outfilename,...
					    eval_lin_outfilename,eval_qfuse_outfilename,...
					    prior,niters,obj_func,cstepHessian,quiet)
% Trains a linear fusion on the dev scores which it applies
% (separately) to the dev scores and eval scores.  It then trains a
% fusion of the dev scores with dev quality measures which it
% applies (separately) to the dev scores (with the dev quality
% measures) and eval scores (with the eval quality measures).  This
% script loads all data from files and saves all resulting score
% sets to files.  It uses 'linear_and_quality_fusion_dev_eval' which works
% with already loaded objects.  
% Inputs:
%   devkeyfilename: The name of the file containing the Key for the
%     dev trials.
%   devscorefilenames: A list of names of files containing the
%     Scores for the dev trials.
%   devQfilenames: A list of names of files containing the quality
%     measures for the dev models and segments.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is.
%   evalndxfilename: The name of the file contraining the Ndx for
%     the eval trials (i.e. the trialmask).
%   evalscorefilenames: A list of names of files containing the
%     Scores for the eval trials.
%   evalQfilenames: A list of names of files containing the quality
%     measures for the eval models and segments.  
%   dev_lin_outfilename: The name of the output file for the dev scores
%     resulting from the linear fusion of the dev scores of the subsystems.
%   dev_qfuse_outfilename: The name of the output file for the
%     dev scores resulting from the quality fusion applied to the
%     dev scores of the subsystems.
%   eval_lin_outfilename: The name of the output file for the
%     eval scores resulting from the linear fusion of the eval
%     scores of the subsystems.
%   eval_qfuse_outfilename: The name of the output file for the
%     eval scores resulting from the quality fusion applied to the
%     eval scores of the subsystems.
%   prior: The effective target prior.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.

assert(nargin==16)
assert(isa(devkeyfilename,'char'))
assert(iscell(devscorefilenames))
assert(isa(evalndxfilename,'char'))
assert(iscell(evalscorefilenames))
assert(iscell(devQfilenames))
assert(iscell(evalQfilenames))
assert(isa(dev_lin_outfilename,'char'))
assert(isa(eval_lin_outfilename,'char'))
assert(isa(dev_qfuse_outfilename,'char'))
assert(isa(eval_qfuse_outfilename,'char'))

key_dev = Key.read(devkeyfilename);
ndx_eval = Ndx.read(evalndxfilename);

dev_scores_obj_array = load_score_files(devscorefilenames);
eval_scores_obj_array = load_score_files(evalscorefilenames);

dev_qual_obj_array = load_qual_files(devQfilenames);
eval_qual_obj_array = load_qual_files(evalQfilenames);

[dev_lin,eval_lin,dev_qual,eval_qual] = linear_and_quality_fusion_dev_eval(key_dev,dev_scores_obj_array,dev_qual_obj_array,Qtrans,...
                                                  ndx_eval,eval_scores_obj_array,eval_qual_obj_array,...
                                                  prior,niters,obj_func,cstepHessian,quiet);

dev_lin.save(dev_lin_outfilename);
eval_lin.save(eval_lin_outfilename);
dev_qual.save(dev_qfuse_outfilename);
eval_qual.save(eval_qfuse_outfilename);

end
