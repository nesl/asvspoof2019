function [Q,params] = outerprod_of_sigmoids(w,qleft,qright)
% 

if nargin==0
    test_this();
    return;
end

[qdim,nleft] = size(qleft);
[qdim2,nright] = size(qright);
assert(qdim==qdim2);
wsz = qdim+1;
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat);
params.tail = wtail;


% fleft = sigmoid_mv2df(fusion_mv2df([],qleft));   %Don't put whead in here, 
% fright = sigmoid_mv2df(fusion_mv2df([],qright)); %or here. Will cause whead to be called twice. 
fleft = fusion_mv2df([],qleft);   %Don't put whead in here, 
fright = fusion_mv2df([],qright); %or here. Will cause whead to be called twice. 
Q = outerprod_of_functions(whead,fleft,fright,nleft,nright);


    function w0 = init_w0(ssat)
    w0 = zeros(wsz,1);
    offs = logit(ssat);
    w0(end) = offs;
    end

end


function test_this()

qleft = randn(3,10);
qright = randn(3,20);
ssat = 0.99;
[sys,params] = outerprod_of_sigmoids([],qleft,qright);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

sig = outerprod_of_sigmoids(w0,qleft,qright),

end

