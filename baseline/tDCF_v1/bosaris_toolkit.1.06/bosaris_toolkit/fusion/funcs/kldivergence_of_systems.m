function KL = kldivergence_of_systems(scores,prior,key)
% Calculates KL divergence between scores for a group of systems on
% a pairwise basis.
% Inputs:
%   scores: s-by-t matrix of scores for s systems and t trials
%   prior: the prior probability
%   key: (optional) supervision in the form of key.tar and key.non
%
% Output:
%   KL:       s-by-s matrix of kl divergences between all pairs of the s
%             input systems. Row index is for reference system, column
%             index for 'evaluated' system.

if exist('key','var') 
    trials = key.tar(:)' | key.non(:)';
    tars = key.tar(trials);
    tars = tars(:)';
    nons = key.non(trials);
    nons = nons(:)';
  
    KL1 = kldivergence_of_systems(scores(:,tars),prior);
    KL2 = kldivergence_of_systems(scores(:,nons),prior);
    KL = prior*KL1 + (1-prior)*KL2;
    return
end

% unsupervised mode returning one KL matrix
T = size(scores,2);


NLS1 = neglogsigmoid(scores + logit(prior));
NLS2 = neglogsigmoid(-scores - logit(prior));
P1 = exp(-NLS1);
P2 = exp(-NLS2);

negP1logQ1 = P1*NLS1';
negP2logQ2 = P2*NLS2';
P1logP1 = -diag(negP1logQ1);
P2logP2 = -diag(negP2logQ2);

KL = (bsxfun(@plus,P1logP1,negP1logQ1) + bsxfun(@plus,P2logP2,negP2logQ2) )/T;
end
