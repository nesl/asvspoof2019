function c = min_cllr(tar_scores, nontar_scores);
% MIN_CLLR: Measure of goodness of detection score output. 
%           MIN_CLLR does NOT measure calibration. 
%
%     c = MIN_CLLR(tar_scores, nontar_scores);
%
%     Input parameters:
%       tar_scores: an array of scores for target trials
%       nontar_scores: an array of scores for non-target trials
%
%     Range: 0 <= c <= 1. 
%     Sense: small c is good, large c is bad. 
%     Reference: c = 1 = min_cllr(a*ones(1,m),a*ones(1,n)) = cllr(0,0), m,n>0, for any constant a, 
%                is the performance of the reference system 
%                that does not process the input speech.
%     Note: In contrast to CLLR, MIN_CLLR cannot get worse than the reference system.
%
%


%
% Author: Niko Brummer, Spescom Datavoice.
% Disclaimer: This code is freely available for any non-commercial purpose, but the author and 
% his employer do not accept any responsibility for any consequences resulting from the use thereof.
% (E.g. getting an EER=50% at the NIST SRE.) 
%
% But if this code does prove useful, we would appreciate citation of the following article:
%   Niko Brummer and Johan du Preez, "Application-Independent Evaluation of Speaker Detection"
%   Computer Speech and Language, to be published, 2005. 

[tar_llrs,nontar_llrs]=opt_loglr(tar_scores,nontar_scores,'raw');
c = cllr(tar_llrs,nontar_llrs);
