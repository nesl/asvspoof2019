function dcf = dcf_at_threshold(tar,non,prior,thresh,normalize)
% Calculates the actual DCF at the supplied threshold values.
% Inputs:
%   tar: A vector of target scores.
%   non: A vector of non-target scores.
%   prior: The effective target prior.
%   thresh: A vector of threshold values.
%   normalize: (optional) true or false.  Return normalized or
%     unnormalized actual DCF.
% Outputs:
%   dcf: Vector of actual DCF values (one value for each threshold
%     value).  The DCF values are normalized if 'normalize' is
%     true.

if ~exist('normalize','var') || isempty(normalize)
    normalize = false;
end

numthresh = length(thresh);
pmiss = zeros(1,numthresh);
pfa = zeros(1,numthresh);
for ii=1:numthresh
    pmiss(ii) = length(tar(tar<thresh(ii))) ./ length(tar);
    pfa(ii) = length(non(non>=thresh(ii))) ./ length(non);
end
dcf = prior.*pmiss + (1-prior).*pfa;

if normalize
    dcf = dcf ./ min(prior,1-prior);
end
