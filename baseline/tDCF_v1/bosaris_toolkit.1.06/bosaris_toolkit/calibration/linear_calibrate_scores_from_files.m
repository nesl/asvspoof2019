function linear_calibrate_scores_from_files(keyfilename,scoresfilename,outfilename,obj_func,niters,prior,addzeros)
% Calibrates scores, loading them from file and saving the calibrated scores to file.
% Inputs:
%   keyfilename: The name of the file containing the key for the trials.
%   scoresfilename: The name of the file for the trial scores.
%   outfilename: The name for the output file for the calibrated scores.
%   obj_func: The objective function (if [], cllr objective is used).
%   niters: The maximum number of iterations in the training of the
%     linear calibration function.
%   prior: The effective target prior.
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).

assert(nargin==7)
assert(isa(keyfilename,'char'))
assert(isa(scoresfilename,'char'))
assert(isa(outfilename,'char'))

key = Key.read(keyfilename);
scr = Scores.read(scoresfilename);
scr_lin = linear_calibrate_scores(scr,key,obj_func,niters,prior,addzeros);
scr_lin.save(outfilename);
