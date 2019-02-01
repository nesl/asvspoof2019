function linear_calibrate_scores_dev_eval_from_files(devkeyfilename,evalndxfilename,devscoresfilename,evalscoresfilename,devoutfilename,evaloutfilename,obj_func,niters,prior,addzeros)
% Calibrates (linear calibration) dev and eval scores, loading them
% from file and saving the calibrated scores to file.
% Inputs:
%   devkeyfilename: The name of the file containing the key for the
%     development trials.
%   evalndxfilename: The name of the file containing the trial
%     list for the eval data.
%   devscoresfilename: The name of the file for the development
%     trial scores.
%   evalscoresfilename: The name of the file for the eval trial scores.
%   devoutfilename: The name for the output file for the calibrated
%     dev scores.
%   evaloutfilename: The name for the output file for the
%     (hopefully) calibrated eval scores.
%   obj_func: The objective function (if [], cllr objective is used).
%   niters: The maximum number of iterations in the training of the
%     linear calibration function.
%   prior: The effective target prior.
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).

assert(nargin==10)
assert(isa(devkeyfilename,'char'))
assert(isa(evalndxfilename,'char'))
assert(isa(devscoresfilename,'char'))
assert(isa(evalscoresfilename,'char'))
assert(isa(devoutfilename,'char'))
assert(isa(evaloutfilename,'char'))

key_dev = Key.read(devkeyfilename);
scr_dev = Scores.read(devscoresfilename);

ndx_eval = Ndx.read(evalndxfilename);
scr_eval = Scores.read(evalscoresfilename);

[scr_dev,scr_eval] = linear_calibrate_scores_dev_eval(scr_dev,scr_eval,key_dev,ndx_eval,obj_func,niters,prior,addzeros);

scr_dev.save(devoutfilename);
scr_eval.save(evaloutfilename);
