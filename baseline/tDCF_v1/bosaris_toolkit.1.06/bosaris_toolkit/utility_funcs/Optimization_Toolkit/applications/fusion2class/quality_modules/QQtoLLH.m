function [LLH,w0] = QQtoLLH(w,qleft,qright,n)
% 

if nargin==0
    test_this();
    return;
end


qleft = [qleft;ones(1,size(qleft,2))];
qright = [qright;ones(1,size(qright,2))];


qdim = size(qleft,1);
qdim2 = size(qright,1);
assert(qdim==qdim2);

q2 = qdim*(qdim+1)/2;
wsz = n*q2;
if nargout>1, w0 = zeros(wsz,1);  end

lh = cell(1,n);
tail = w;
for i=1:n
    [wi,tail] = splitvec_fh(q2,tail);
    lh{i} = AWB_fh(qleft',qright,tril_to_symm_fh(qdim,wi));
end

LLH = interleave(w,lh);



end


function test_this()

qleft = randn(3,3);
qright = randn(3,2);
[sys,w0] = QQtoLLH([],qleft,qright,2);

test_MV2DF(sys,w0);


end
