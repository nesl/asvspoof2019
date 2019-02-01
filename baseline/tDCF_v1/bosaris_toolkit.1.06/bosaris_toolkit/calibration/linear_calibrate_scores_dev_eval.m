function [scr_dev_lin,scr_eval_lin] = linear_calibrate_scores_dev_eval(scr_dev,scr_eval,key_dev,ndx_eval,obj_func,niters,prior,addzeros)
% A function to calibrate a set of scores (eval) using another set
% as reference (dev).  The function requires a key for the dev
% scores (supervised) and an ndx for the eval scores
% (unsupervised).  It trains a linear calibration (scaling and
% offset) and then applies the calibration function to both sets of
% scores.  Comparing the act_dcf and min_dcf values at the
% operating point gives an indication of the success of the
% calibration (assuming the score distribution is the same in the
% two sets --- if not, don't bother calibrating).  
% Inputs:
%   scr_dev: The development scores.
%   scr_eval: The eval scores.
%   key_dev: The Key for the development scores i.e. must have
%     'tar' and 'non' fields.
%   ndx_eval: The Ndx for the eval scores i.e. must have a
%     'trialmask' field.
%   obj_func: The objective function (if [], cllr objective is used).
%   niters: The maximum number of iterations in the training of the
%     linear calibration function.
%   prior: The effective target prior.
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).
% Outputs:
%   scr_dev_lin: The calibrated development scores.
%   scr_eval_lin: The calibrated eval scores.

assert(nargin==8)
assert(isa(scr_dev,'Scores'))
assert(isa(scr_eval,'Scores'))
assert(isa(key_dev,'Key'))
assert(isa(ndx_eval,'Ndx'))
assert(scr_dev.validate())
assert(scr_eval.validate())
assert(key_dev.validate())
assert(ndx_eval.validate())

[tar,non] = scr_dev.get_tar_non(key_dev);
logprint(Logger.Info,'training calibration\n')
[flin,nxe,w_lin] = train_linear_calibration(tar,non,prior,obj_func,niters,true);

logprint(Logger.Info,'calibrating scores\n')
scr_dev_lin = scr_dev.align_with_ndx(key_dev);
scr_eval_lin = scr_eval.align_with_ndx(ndx_eval);

scr_dev_lin = scr_dev_lin.transform(flin);
scr_eval_lin = scr_eval_lin.transform(flin);

logprint(Logger.Info,'displaying calibration results\n')
logprint(Logger.Info,'weights: scaling %f, offset %f\n',w_lin(1),w_lin(2))
res = Results(scr_dev_lin,key_dev);
logprint(Logger.Info,'norm_act_dcf = %g, norm_min_dcf = %g, prbep = %g, nxe = %g\n',res.get_norm_act_dcf(prior),res.get_norm_min_dcf(prior),res.get_prbep(),nxe);  

if addzeros
    scr_dev_lin = scr_dev_lin.set_missing_to_value(key_dev,0.0);
    scr_eval_lin = scr_eval_lin.set_missing_to_value(ndx_eval,0.0);    
end

assert(scr_dev_lin.validate())
assert(scr_eval_lin.validate())

end
