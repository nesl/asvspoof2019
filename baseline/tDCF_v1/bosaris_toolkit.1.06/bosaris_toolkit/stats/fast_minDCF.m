function [minDCF,Pmiss,Pfa,prbep,eer] = fast_minDCF(tar,non,plo,normalize)
% Inputs:
%
%   tar: vector of target scores
%   non: vector of non-target scores
%   plo: vector of prior-log-odds: plo = logit(Ptar) 
%                                      = log(Ptar) - log(1-Ptar)
%
%   normalize: if true, return normalized minDCF, else un-normalized.
%              (optional, default = false)
%
% Output:
%   minDCF: a vector with one value for every element of plo
%            Note that minDCF is parametrized by plo:
%   
%        minDCF(Ptar) = min_t Ptar * Pmiss(t) + (1-Ptar) * Pfa(t) 
%
%      where t is the adjustable decision threshold and
%          Ptar = sigmoid(plo) = 1./(1+exp(-plo))
%      If normalize == true, then the returned value is
%        minDCF(Ptar) / min(Ptar,1-Ptar).
%
%
%   Pmiss: a vector with one value for every element of plo.
%          This is Pmiss(tmin), where tmin is the minimizing threshold
%          for minDCF, at every value of plo. Pmiss is not altered by
%          parameter 'normalize'.
%
%   Pfa: a vector with one value for every element of plo.
%          This is Pfa(tmin), where tmin is the minimizing threshold for
%          minDCF, at every value of plo. Pfa is not altered by
%          parameter 'normalize'.
%
%   prbep: precision-recall break-even point: Where #FA == #miss
%
%   eer: the equal error rate.
%
%   Note, for the un-normalized case:
%     minDCF(plo) = sigmoid(plo).*Pfa(plo) + sigmoid(-plo).*Pmiss(plo)

if nargin==0
    test_this();
    return
end

assert(isvector(tar))
assert(isvector(non))
assert(isvector(plo))

if ~exist('normalize','var') || isempty(normalize)
    normalize = false;
end

plo = plo(:);
[Pmiss,Pfa] = rocch(tar,non);
if nargout > 3
    Nmiss = Pmiss * length(tar);
    Nfa = Pfa * length(non);
    prbep = rocch2eer(Nmiss,Nfa);
end
if nargout > 4
    eer = rocch2eer(Pmiss,Pfa);
end
Ptar = sigmoid(plo);
Pnon = sigmoid(-plo);
cdet = [Ptar,Pnon]*[Pmiss(:)';Pfa(:)'];
[minDCF,ii] = min(cdet,[],2);
if nargout>1
    Pmiss = Pmiss(ii);
    Pfa = Pfa(ii);
end

if normalize
    minDCF = minDCF ./ min(Ptar,Pnon);
end

end

function test_this

close all;
plo = -20:0.01:20;

tar = randn(1,1e4)+4;
non = randn(1,1e4);
minDCF = fast_minDCF(tar,non,plo,true);
%sminDCF = slow_minDCF(tar,non,plo,true);
%plot(plo,minDCF,'r',plo,sminDCF,'k');
plot(plo,minDCF,'r');
hold on;

tar = randn(1,1e5)+4;
non = randn(1,1e5);
minDCF = fast_minDCF(tar,non,plo,true);
plot(plo,minDCF,'g')

tar = randn(1,1e6)+4;
non = randn(1,1e6);
minDCF = fast_minDCF(tar,non,plo,true);
plot(plo,minDCF,'b')
hold off;

end
