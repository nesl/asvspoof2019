function [fusion,w0] = qfuser_linear(w,scores,scrQ,ndx,w_init)
% This function does the actual quality fusion (and is passed to
% the training function when training the quality fusion weights).
% The scores from the linear fusion are added to the combined
% quality measure for each trial to produce the final score.
% Inputs:
%   w: The trained quality fusion weights.  If empty, this function
%     returns a function handle.
%   scores: A matrix of scores where the number of rows is the
%     number of systems to be fused and the number of columns
%     is the number of scores.
%   scrQ: An object of type Quality containing the quality measures
%     for models and segments.
%   ndx: A Key or Ndx object indicating trials.
%   w_init: The trained weights from the linear fusion (without
%     quality measures) training.
% Outputs:
%   fusion: If w is supplied, fusion is a vector of fused scores.
%     If w is not supplied, fusion is a function handle to a
%     function that takes w as input and produces a vector of fused
%     scores as output.  This function wraps the scores and quality
%     measures. 
%   w0: Initial weights for starting the quality fusion training.

if nargin==0
    test_this();
    return
end

assert(isa(scrQ,'Quality'))
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))

if ~exist('w_init','var')
    assert(~isempty(w),'If w=[], then w_init must be supplied.');
    w_init = w;
end

[m,n] = size(scores);
wlin_sz = m+1;

% linear fuser
f1 = linear_fuser([],scores);
w1 = w_init(1:wlin_sz);
[wlin,wq] = splitvec_fh(wlin_sz);
f1 = f1(wlin);

[q,n1] = size(scrQ.modelQ);
[q2,n2] = size(scrQ.segQ);
assert(q==q2);

scrQ.modelQ = [scrQ.modelQ;ones(1,n1)];
scrQ.segQ = [scrQ.segQ;ones(1,n2)];
q = q + 1;

f2 = AWB_sparse(scrQ,ndx,tril_to_symm_fh(q));
f2 = f2(wq);

wq_sz = q*(q+1)/2;
w3 = zeros(wq_sz,1);

% assemble
fusion = sum_of_functions(w,[1,1],f1,f2);
w0 = [w1;w3];

end



function test_this()

k = 2;

m = 3;
n = 4;
q = 2;
qual = Quality();
qual.modelQ = randn(q,m);
qual.segQ = randn(q,n);
ndx = Ndx();
ndx.trialmask = false(m,n);
ndx.trialmask(1,1:2) = true;
ndx.trialmask(2:3,3:4) = true;

scores = randn(k,sum(ndx.trialmask(:)));

w_init = [randn(k+1,1)]; % linear init

[fusion,w0] = qfuser_linear([],scores,qual,ndx,w_init);

test_MV2DF(fusion,w0);

[fusion(w0),linear_fuser(w_init,scores)]

end
