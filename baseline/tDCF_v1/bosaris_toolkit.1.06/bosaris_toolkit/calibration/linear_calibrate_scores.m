function scr_lin = linear_calibrate_scores(scr,key,obj_func,niters,prior,addzeros)
% A function for doing 'cheating' calibration on scores.  It trains
% a linear calibration (scaling and offset) on the scores and then
% applies the calibration to the same scores.  
% Inputs:
%   scr: The object (of class Scores) containing the scores to be
%     calibrated. 
%   key: The Key indicating target and non-target trials.
%   obj_func: The objective function for the calibration training.  The
%     default is cllr objective.
%   niters: The maximum number of iterations in the calibration
%     training.
%   prior: The effective target prior.  
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).
% Outputs:
%   scr_lin: The calibrated version of the input scores.

assert(nargin==6)
assert(isa(scr,'Scores'))
assert(isa(key,'Key'))
assert(scr.validate())
assert(key.validate())

[tar,non] = scr.get_tar_non(key);
logprint(Logger.Info,'training calibration\n')
[flin,nxe,w_lin] = train_linear_calibration(tar,non,prior,obj_func,niters,true);

logprint(Logger.Info,'calibrating scores\n')
scr_lin = scr.align_with_ndx(key);
scr_lin = scr_lin.transform(flin);

logprint(Logger.Info,'displaying calibration results\n')
logprint(Logger.Info,'weights: scaling %f, offset %f\n',w_lin(1),w_lin(2))
res = Results(scr_lin,key);
logprint(Logger.Info,'norm_act_dcf = %g, norm_min_dcf = %g, prbep = %g, nxe = %g\n',res.get_norm_act_dcf(prior),res.get_norm_min_dcf(prior),res.get_prbep(),nxe); 

if addzeros
    scr_lin = scr_lin.set_missing_to_value(key,0.0);
end

assert(scr_lin.validate())

end
