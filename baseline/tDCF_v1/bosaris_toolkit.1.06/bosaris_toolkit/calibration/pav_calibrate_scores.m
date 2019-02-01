function scr_pav = pav_calibrate_scores(scr,key,prior,score_offset,addzeros)
% A function for doing 'cheating' calibration on scores.  It trains
% a PAV transformation on the scores and then applies the
% transformation function to the same scores.  
% Inputs:
%   scr: The object (of class Scores) containing the scores to be
%     calibrated. 
%   key: The Key indicating target and non-target trials.
%   prior: The effective target prior.  
%   score_offset: This is used to make the transform monotonically
%     increasing by tilting each flat portion of the PAV output.
%     The tilt is controlled by this value, and making it zero
%     results in no tilt.
%   addzeros: If true, missing scores (required by key but not
%     present in scr) are added (with value zero).
% Outputs:
%   scr_pav: The calibrated version of the input scores.

assert(nargin==5)
assert(isa(scr,'Scores'))
assert(isa(key,'Key'))
assert(scr.validate())
assert(key.validate())

[tar,non] = scr.get_tar_non(key);
logprint(Logger.Info,'training calibration\n')
pav_trans = pav_calibration(tar,non,score_offset);

logprint(Logger.Info,'calibrating scores\n')
scr_pav = scr.align_with_ndx(key);
scr_pav = scr_pav.transform(pav_trans);

logprint(Logger.Info,'displaying calibration results\n')
res = Results(scr_pav,key);
logprint(Logger.Info,'norm_act_dcf = %g, norm_min_dcf = %g, prbep = %g\n',res.get_norm_act_dcf(prior),res.get_norm_min_dcf(prior),res.get_prbep());

% fill in missing trials (we assign zero for missing scores because
% for properly calibrated scores, zero means that the score gives
% us no information about the trial).
if addzeros
    scr_pav = scr_pav.set_missing_to_value(key,0.0);
end

assert(scr_pav.validate())

end
