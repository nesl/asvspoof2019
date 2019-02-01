function [P,params] = QQtoP(w,qleft,qright,n)
% 

if nargin==0
    test_this();
    return;
end


qleft = [qleft;ones(1,size(qleft,2))];
qright = [qright;ones(1,size(qright,2))];


[qdim,nleft] = size(qleft);
[qdim2,nright] = size(qright);
assert(qdim==qdim2);
q2 = qdim*(qdim+1)/2;
wsz = n*q2;
[whead,wtail] = splitvec_fh(wsz);
params.get_w0 = @() zeros(wsz,1); 
params.tail = wtail;

lh = cell(1,n);
for i=1:n
    [wi,whead] = splitvec_fh(q2,whead);
    lh{i} = AWB_fh(qleft',qright,tril_to_symm_fh(qdim,wi));
end

P = exp_mv2df(logsoftmax_mv2df(interleave(w,lh),n));
%P = interleave(w,lh);




end


function test_this()

qleft = randn(3,3);
qright = randn(3,2);
[sys,params] = QQtoP([],qleft,qright,2);

w0 = params.get_w0();
test_MV2DF(sys,w0);

P  = sys(w0),

end

