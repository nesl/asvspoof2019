function E = evalAll(scores,key,prior)
% Calculates the actual dcf, min dcf, and prbep for each input
% system (which may include fusions).
% Inputs:
%   scores: An m-by-n matrix of scores where m is the number of
%     systems (possibly including fusions) and n is the number of
%     trials. 
%   key: A Key object used to determine target and non-target
%     scores. 
%   prior: The effective target prior.
% Outputs:
%   E: an m-by-3 matrix.  Each row corresponds to a row in the
%     scores matrix i.e. to an input system.  m(:,1) are actual dcf
%     values, m(:,2) are min dcf values and m(:,3) are prbep values.

assert(nargin==3)
assert(isa(key,'Key'))

m = size(scores,1);

trials = key.tar(:)' | key.non(:)';
tars = key.tar(trials);
tars = tars(:)';
nons = key.non(trials);
nons = nons(:)';

E = zeros(m,3);
for i=1:m
    tar = scores(i,tars);
    non = scores(i,nons);
    [dcf,mindcf,prbep] = fastEval(tar,non,prior);
    E(i,:) = [dcf*100,mindcf*100,prbep];
end
