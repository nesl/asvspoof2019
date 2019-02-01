function [dcf,Pmiss,Pfa] = fast_actDCF(tar,non,plo,normalize)
% Computes the actual average cost of making Bayes decisions with scores
% calibrated to act as log-likelihood-ratios. The average cost (DCF) is 
% computed for a given range of target priors and for unity cost of error.
% If un-normalized, DCF is just the Bayes error-rate.
%
%  Usage examples:  dcf = fast_actDCF(tar,non,-10:0.01:0)
%                   norm_dcf = fast_actDCF(tar,non,-10:0.01:0,true)
%                   [dcf,pmiss,pfa] = fast_actDCF(tar,non,-10:0.01:0)
%
%  Inputs:
%    tar: a vector of T calibrated target scores
%    non: a vector of N calibrated non-target scores
%         Both are assumed to be of the form 
%
%               log P(data | target)
%       llr = -----------------------
%             log P(data | non-target)
%
%         where log is the natural logarithm.
%
%    plo: an ascending vector of log-prior-odds, plo = logit(Ptar) 
%                                                    = log(Ptar) - log(1-Ptar)
%
%    normalize: (optional, default false) return normalized dcf if true.
%
%
%   Outputs: 
%     dcf: a vector of DCF values, one for every value of plo.
%     
%             dcf(plo) = Ptar(plo)*Pmiss(plo) + (1-Ptar(plo))*Pfa(plo)
%
%          where Ptar(plo) = sigmoid(plo) = 1./(1+exp(-plo)) and
%          where Pmiss and Pfa are computed by counting miss and false-alarm
%          rates, when comparing 'tar' and 'non' scores to the Bayes decision
%          threshold, which is just -plo. If 'normalize' is true, then dcf is
%          normalized by dividing by min(Ptar,1-Ptar).
%
%      Pmiss: empirical actual miss rate, one value per element of plo.
%             Pmiss is not altered by parameter 'normalize'.
%
%      Pfa: empirical actual false-alarm rate, one value per element of plo.
%           Pfa is not altered by parameter 'normalize'.
%
% Note, the decision rule applied here is to accept if 
%
%    llr >= Bayes threshold. 
%
% or reject otherwise. The >= is a consequence of the stability of the 
% sort algorithm , where equal values remain in the original order.
%
%
if nargin==0
    test_this();
    return
end

assert(isvector(tar))
assert(isvector(non))
assert(isvector(plo))

assert(issorted(plo),'Parameter plo must be in ascending order.');

tar = tar(:)';
non = non(:)';
plo = plo(:)';

if ~exist('normalize','var') || isempty(normalize)
    normalize = false;
end

D = length(plo);
T = length(tar);
N = length(non);

[s,ii] = sort([-plo,tar]);  % -plo are thresholds
r = zeros(1,T+D);
r(ii) = 1:T+D; 
r = r(1:D); % rank of thresholds
Pmiss = r-(D:-1:1);

[s,ii] = sort([-plo,non]);  % -plo are thresholds
r = zeros(1,N+D);
r(ii) = 1:N+D; 
r = r(1:D); % rank of thresholds
Pfa = N - r + (D:-1:1);

Pmiss = Pmiss / T;
Pfa = Pfa / N;


Ptar = sigmoid(plo);
Pnon = sigmoid(-plo);
dcf = Ptar.*Pmiss + Pnon.*Pfa;

if normalize
    dcf = dcf ./ min(Ptar,Pnon);
end

end

function test_this()

tar = [1 2 5 7];
non = [-7 -5 -2 -1];
plo = -6:6;

[dcf,Pmiss,Pfa] = fast_actDCF(tar,non,plo)


end
