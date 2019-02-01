function pb = prbep(tar,non)
% Calculates the PRBEP value for a set of target and non-target scores.
% Inputs:
%   tar: vector of target scores
%   non: vector of non-target scores
% Output:
%   prbep: precision-recall break-even point: Where #FA == #miss

assert(isvector(tar))
assert(isvector(non))

[Pmiss,Pfa] = rocch(tar,non);
Nmiss = Pmiss * length(tar);
Nfa = Pfa * length(non);
pb = rocch2eer(Nmiss,Nfa);
