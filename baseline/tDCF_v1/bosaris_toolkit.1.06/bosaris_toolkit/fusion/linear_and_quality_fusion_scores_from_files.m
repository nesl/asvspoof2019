function linear_and_quality_fusion_scores_from_files(keyfilename,scorefilenames,Qfilenames,Qtrans,...
					  lin_outfilename,qfuse_outfilename,...
					  prior,niters,obj_func,cstepHessian,quiet)
% Fuses scores (using linear fusion) and then fuses in quality
% measures.  This function does the loading of the key and scores
% and saves the fused scores.  It uses 'linear_and_quality_fusion_scores'
% which works with already loaded scores and key.  
% Inputs:
%   keyfilename: The name of the file containing the Key for the trials.
%   scorefilenames: A list of names of files containing the Scores
%     for the trials.
%   Qfilenames: A list of names of files containing the quality
%     measures for the models and segments.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is.
%   lin_outfilename: The name of the output file for the scores
%     resulting from the linear fusion of the scores of the subsystems.
%   qfuse_outfilename: The name of the output file for the scores
%     resulting from the quality fusion applied to the scores of
%     the subsystems.
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
assert(isa(keyfilename,'char'))
assert(iscell(scorefilenames))
assert(iscell(Qfilenames))
assert(isa(lin_outfilename,'char'))
assert(isa(qfuse_outfilename,'char'))

key = Key.read(keyfilename);
scores_obj_array = load_score_files(scorefilenames);
qual_obj_array = load_qual_files(Qfilenames);

[scr_lin,scr_qual] = linear_and_quality_fusion_scores(key,scores_obj_array,qual_obj_array,Qtrans,...
					   prior,niters,obj_func,cstepHessian,quiet);

scr_lin.save(lin_outfilename);
scr_qual.save(qfuse_outfilename);

end
