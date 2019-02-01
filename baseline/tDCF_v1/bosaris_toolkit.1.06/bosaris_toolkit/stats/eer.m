function eer_val = eer(tar,non)
% Calculates the equal error rate from a set of target and
% non-target scores.
% Inputs:
%   tar: vector of target scores
%   non: vector of non-target scores
% Output:
%   eer: the equal error rate.

assert(isvector(tar))
assert(isvector(non))

[Pmiss,Pfa] = rocch(tar,non);
eer_val = rocch2eer(Pmiss,Pfa);
