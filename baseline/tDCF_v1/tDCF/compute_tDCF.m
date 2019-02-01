function [tDCF_norm, CM_thresholds] = compute_tDCF(bonafide_score_cm, spoof_score_cm, Pfa_asv, Pmiss_asv, Pmiss_spoof_asv, cost_model, print_cost)

% function [tDCF_norm, CM_thresholds] = compute_tDCF(CM_bonafide_score, CM_spoof_score, Pfa_asv, Pmiss_asv, Pmiss_spoof_asv, cost_model, print_cost)
% 
% Compute Tandem Detection Cost Function (t-DCF) [1] for a fixed ASV system. 
% In brief, t-DCF returns a detection cost of a cascaded system of this form,
% 
%   Speech waveform -> [CM] -> [ASV] -> decision
% 
% where CM stands for countermeasure and ASV for automatic speaker
% verification. The CM is therefore used as a 'gate' to decided whether or
% not the input speech sample should be passed onwards to the ASV system.
% Generally, both CM and ASV can do detection errors. Not all those errors
% are necessarily equally cost, and not all types of users are necessarily
% equally likely. The tandem t-DCF gives a principled with to compare
% different spoofing countermeasures under a detection cost function
% framework that takes that information into account.
% 
% INPUTS:
% 
%   bonafide_score_cm   A vector of POSITIVE CLASS (bona fide or human) 
%                       detection scores obtained by executing a spoofing 
%                       countermeasure (CM) on some positive evaluation trials.
%                       trial represents a bona fide case. 
%   spoof_score_cm      A vector of NEGATIVE CLASS (spoofing attack)
%                       detection scores obtained by executing a spoofing
%                       CM on some negative evaluation trials.
%   Pfa_asv             False alarm (false acceptance) rate of the ASV
%                       system that is evaluated in tandem with the CM.
%                       Assumed to be in fractions, not percentages.
%   Pmiss_asv           Miss (false rejection) rate of the ASV system that
%                       is evaluated in tandem with the spoofing CM.
%                       Assumed to be in fractions, not percentages.
%   Pmiss_spoof_asv     Miss rate of spoof samples of the ASV system that
%                       is evaluated in tandem with the spoofing CM. That
%                       is, the fraction of spoof samples that were
%                       rejected by the ASV system. 
%   cost_model          A struct that contains the parameters of t-DCF,
%                       with the following fields.
% 
%                       Ptar        Prior probability of target speaker.
%                       Pnon        Prior probability of nontarget speaker (zero-effort impostor)
%                       Psoof       Prior probability of spoofing attack.
%                       Cmiss_asv   Cost of ASV falsely rejecting target.
%                       Cfa_asv     Cost of ASV falsely accepting nontarget.
%                       Cmiss_cm    Cost of CM falsely rejecting target.
%                       Cfa_cm      Cost of CM falsely accepting spoof.
%                           
%   print_cost          Print a summary of the cost parameters and the
%                       implied t-DCF cost function? 
% 
% OUTPUTS:
% 
%   tDCF_norm           Normalized t-DCF curve across the different CM
%                       system operating points; see [2] for more details.
%                       Normalized t-DCF > 1 indicates a useless
%                       countermeasure (as the tandem system would do
%                       better without it). min(tDCF_norm) will be the
%                       minimum t-DCF used in ASVspoof 2019 [2].
%   CM_thresholds       Vector of same size as tDCF_norm corresponding to
%                       the CM threshold (operating point). 
% 
% NOTE:
% o     In relative terms, higher detection scores values are assumed to 
%       indicate stronger support for the bona fide hypothesis.
% o     You should provide real-valued soft scores, NOT hard decisions. The
%       recommendation is that the scores are log-likelihood ratios (LLRs)
%       from a bonafide-vs-spoof hypothesis based on some statistical model.
%       This, however, is NOT required. The scores can have arbitrary range
%       and scaling.
% o     Pfa_asv, Pmiss_asv, Pmiss_spoof_asv are in fractions, not percentages. 
%                           
% References:
% 
%   [1] T. Kinnunen, K.-A. Lee, H. Delgado, N. Evans, M. Todisco, 
%       M. Sahidullah, J. Yamagishi, D.A. Reynolds: "t-DCF: a Detection 
%       Cost Function for the Tandem Assessment of Spoofing Countermeasures 
%       and Automatic Speaker Verification", Proc. Odyssey 2018: the
%       Speaker and Language Recognition Workshop, pp. 312--319, Les Sables d'Olonne,
%       France, June 2018 (https://www.isca-speech.org/archive/Odyssey_2018/pdfs/68.pdf)
% 
%   [2] ASVspoof 2019 challenge evaluation plan 
%       TODO: <add link>

% Check all required inputs were provided 
if nargin < 7
    error('You need to provide all the seven input parameters.');
end

% Sanity check of cost parameters
if any([cost_model.Cfa_asv cost_model.Cmiss_asv cost_model.Cfa_cm cost_model.Cmiss_cm] < 0)
    warning('Usually the cost values should be positive');
end
if any([cost_model.Ptar cost_model.Pnon cost_model.Pspoof] < 0) | (abs(cost_model.Ptar + cost_model.Pnon + cost_model.Pspoof - 1) > 1e-10)
    error('Your prior probabilities should be positive and sum up to one.');
end

% Sanity check of scores
bonafide_score_cm = bonafide_score_cm(:);
spoof_score_cm = spoof_score_cm(:);
if any(~isfinite([bonafide_score_cm; spoof_score_cm])) | any(isnan([bonafide_score_cm; spoof_score_cm]));
    error('Your scores contain NaN or Inf.');
end

% Sanity check that inputs are scores and not decisions
Nuniq = length(unique([bonafide_score_cm; spoof_score_cm]));
if Nuniq < 3
    error('You should provide soft CM scores - not binary decisions');
end

% Obtain miss and false alarm rates of CM
[Pmiss_cm, Pfa_cm, CM_thresholds] = compute_det_curve(bonafide_score_cm, spoof_score_cm);

% Constants - see ASVspoof 2019 evaluation plan
C1 = cost_model.Ptar * (cost_model.Cmiss_cm - cost_model.Cmiss_asv * Pmiss_asv) - cost_model.Pnon * cost_model.Cfa_asv * Pfa_asv;
C2 = cost_model.Cfa_cm * cost_model.Pspoof * (1 - Pmiss_spoof_asv);

% Sanity check of the weights
if (C1 < 0) || (C2 < 0)
    error('You should never see this error but I cannot evalute tDCF with negative weights - please check whether your ASV error rates are correctly computed?')
end

% Obtain t-DCF curve for all thresholds
tDCF = C1 .* Pmiss_cm + C2 .* Pfa_cm;

% Normalized t-DCF
tDCF_norm = tDCF./min(C1, C2);

% Everything should be fine if reaching here.
if print_cost
    
    fprintf('t-DCF evaluation from [Nbona=%d, Nspoof=%d] trials\n\n', length(bonafide_score_cm), length(spoof_score_cm));
    
    fprintf('t-DCF MODEL\n');
    fprintf('     Ptar        \t\t= %5.5f\t\t Prior probability of target user\n', cost_model.Ptar);
    fprintf('     Pnon        \t\t= %5.5f\t\t Prior probability of nontarget user - some other human user\n', cost_model.Pnon);
    fprintf('     Pspoof      \t\t= %5.5f\t\t Prior probability of a spoofing attack\n', cost_model.Pspoof);
    fprintf('     Cfa_asv     \t\t= %5.5f\t\t Cost of ASV falsely accepting a nontarget\n', cost_model.Cfa_asv);
    fprintf('     Cmiss_asv   \t\t= %5.5f\t\t Cost of ASV falsely rejecting target speaker\n', cost_model.Cmiss_asv);
    fprintf('     Cfa_cm      \t\t= %5.5f\t\t Cost of CM falsely passing a spoof to ASV system\n', cost_model.Cfa_cm);
    fprintf('     Cmiss_cm    \t\t= %5.5f\t\t Cost of CM falsely blocking target utterance which never reaches ASV\n\n', cost_model.Cmiss_cm);
    fprintf('     Implied normalized t-DCF function (depends on t-DCF parameters and ASV errors), s=CM threshold\n\n');
    if C2 == min(C1, C2)
        fprintf('          tDCF_norm(s) = %5.5f x Pmiss_cm(s) + Pfa_cm(s)\n', C1/C2);
    else
        fprintf('          tDCF_norm(s) = Pmiss_cm(s) + %5.5f x Pfa_cm(s)\n', C2/C1);
    end
    fprintf('\n');
    
end