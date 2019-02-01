function [fusion,w0] = qfuser_v7(w,scores,wfuse)

if nargin==0
    test_this();
    return;
end


% block 1
f1 = linear_fuser([],scores.scores);
w1 = wfuse;
[whead,wtail] = splitvec_fh(length(w1));
f1 = f1(whead);

% block 2
modelQ = scores.modelQ;
[q,n1] = size(modelQ);
modelQ = [modelQ;ones(1,n1)];
segQ = scores.segQ;
[q2,n2] = size(segQ);
segQ = [segQ;ones(1,n2)];
assert(q==q2);
q = q + 1;

wq = q*(q+1)/2;
f2 = AWB_fh(modelQ',segQ,tril_to_symm_fh(q));
w2 = zeros(wq,1);
[whead,rs] = splitvec_fh(wq,wtail);
f2 = f2(whead);

% block 3
n = size(scores.scores,2);
map = @(rs) repmat(rs,n,1);
transmap =@(RS) sum(reshape(RS,2,[]),2);
RS = linTrans(rs,map,transmap);
w3 = [-10;-10];



% assemble
f12 = sum_of_functions([],[1,1],f1,f2);
XRS = stack(w,f12,RS);
fusion = scalibration_fh(XRS);



w0 = [w1;w2;w3];




end


function test_this()

m = 3;
k = 2;
n1 = 4;
n2 = 5;


scores.scores = randn(m,n1*n2);
scores.modelQ = randn(k,n1);
scores.segQ = randn(k,n2);

wfuse = [1,2,3,4]';

[fusion,w0] = qfuser_v7([],scores,wfuse);

test_MV2DF(fusion,w0);

[fusion(w0),linear_fuser(wfuse,scores.scores)]



end
