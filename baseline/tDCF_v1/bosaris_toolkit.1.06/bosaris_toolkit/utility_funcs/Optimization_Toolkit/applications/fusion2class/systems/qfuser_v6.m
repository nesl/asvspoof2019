function [fusion,w0] = qfuser_v6(w,scores,wfuse)

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
r = AWB_fh(modelQ',segQ,tril_to_symm_fh(q));
[whead,wtail] = splitvec_fh(wq,wtail);
r = r(whead);
w2 = zeros(wq,1);w2(end) = -5;


% block 3
s = AWB_fh(modelQ',segQ,tril_to_symm_fh(q,wtail));
w3 = w2;



% assemble
rs = stack([],r,s);
fusion = scalibration_fh(stack(w,f1,rs));
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

[fusion,w0] = qfuser_v6([],scores,wfuse);

test_MV2DF(fusion,w0);

[fusion(w0),linear_fuser(wfuse,scores.scores)]

%fusion(w0)


end
