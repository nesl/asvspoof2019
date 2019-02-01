function [scr_dev_pav,scr_eval_pav] = pav_calibrate_scores_dev_eval(scr_dev,scr_eval,key_dev,ndx_eval,prior,score_offset,addzeros)
% A function to calibrate a set of scores (eval) using another set
% as reference (dev).  The function requires a key for the dev
% scores (supervised) and an ndx for the eval scores
% (unsupervised).  It trains a PAV transformation and then applies
% the transformation to both sets of scores.  Comparing the act_dcf
% and min_dcf values at the operating point gives an indication of
% the success of the calibration (assuming the score distribution
% is the same in the two sets --- if not, don't bother calibrating).  
% Inputs:
%   scr_dev: The development scores.
%   scr_eval: The eval scores.
%   key_dev: The Key for the development scores i.e. must have
%     'tar' and 'non' fields.
%   ndx_eval: The Ndx for the eval scores i.e. must have a
%     'trialmask' field.
%   prior: The effective target prior.
%   score_offset: This is used to make the transform monotonically
%     increasing by tilting each flat portion of the PAV output.
%     The tilt is controlled by this value, and making it zero
%     results in no tilt.
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).
% Outputs:
%   scr_dev_pav: The calibrated development scores.
%   scr_eval_pav: The calibrated eval scores.


assert(nargin==7)
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
pav_trans = pav_calibration(tar,non,score_offset);

logprint(Logger.Info,'calibrating scores\n')
scr_dev_pav = scr_dev.align_with_ndx(key_dev);
scr_eval_pav = scr_eval.align_with_ndx(ndx_eval);

scr_dev_pav = scr_dev_pav.transform(pav_trans);
scr_eval_pav = scr_eval_pav.transform(pav_trans);

logprint(Logger.Info,'displaying calibration results\n')
res = Results(scr_dev_pav,key_dev);
logprint(Logger.Info,'norm_act_dcf = %g, norm_min_dcf = %g, prbep = %g\n',res.get_norm_act_dcf(prior),res.get_norm_min_dcf(prior),res.get_prbep());   

if addzeros
    scr_dev_pav = scr_dev_pav.set_missing_to_value(key_dev,0.0);
    scr_eval_pav = scr_eval_pav.set_missing_to_value(ndx_eval,0.0);    
end

assert(scr_dev_pav.validate())
assert(scr_eval_pav.validate())

end
