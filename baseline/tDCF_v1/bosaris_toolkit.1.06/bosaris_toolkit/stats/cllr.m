function c = cllr(tar_llrs, nontar_llrs);
% CLLR: Measure of goodness of log-likelihood-ratio detection output. This measures both: 
%       - The quality of the score (over the whole DET curve), and
%       - The quality of the calibration 
%
% 		c = CLLR(tar_llrs, nontar_llrs);
%
%     Input parameters:
%       tar_llrs: an array of log-likelihood-ratios for target trials
%       nontar_llrs: an array of log-likelihood-ratios for non-target trials
%
%     Note: 'log' in log-likelihood-ratio, denotes the natural logarithm (base e).
%
%
%     Range: 0 <= c <= inf. 
%     Sense: small c is good, large c is bad. 
%     Reference: c = 1 = cllr(zeros(1,m),zeros(1,n)), m,n>0, is the performance of the 
%                reference system that does not process the input speech.
%     Note: Systems with bad calibration can do much worse than the reference system!
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



% target trials 
c1 = mean(neglogsigmoid(tar_llrs))/log(2);
  
% non_target trials 
c2 = mean(neglogsigmoid(-nontar_llrs))/log(2);

% Cllr
c = (c1+c2)/2;
