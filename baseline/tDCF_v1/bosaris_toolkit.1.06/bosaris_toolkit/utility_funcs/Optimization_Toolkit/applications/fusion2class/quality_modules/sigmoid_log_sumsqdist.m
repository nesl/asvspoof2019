function [sig,params] = sigmoid_log_sumsqdist(w,data1,data2,ndx1,ndx2,ddim)
% 
% Similar to prod_sigmoid_logdist, but adds square distances from two sides
% before doing sigmoid(log()).
%


if nargin==0
    test_this();
    return;
end

datadim = size(data1,1);
assert(datadim==size(data2,1),'data1 and data2 must have same number of rows');
assert(length(ndx1)==length(ndx2));
assert(max(ndx1)<=size(data1,2));
assert(max(ndx2)<=size(data2,2));

wsz = ddim*(datadim+1);
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat);
params.tail = wtail;


sqd1 = square_distance_mv2df([],data1,ddim); %Don't put whead in here, 
sqd2 = square_distance_mv2df([],data2,ddim); %or here. Will cause whead to be called twice. 

% distribute over trials
distrib = duplicator_fh(ndx1,size(data1,2));
sqd1 = distrib(sqd1);
distrib = duplicator_fh(ndx2,size(data2,2));
sqd2 = distrib(sqd2);

sumsq_dist = sum_of_functions([],[1,1],sqd1,sqd2); 
sig = one_over_one_plus_w_mv2df(sumsq_dist); 
sig = sig(whead); %Finally plug whead in here.



    function w0 = init_w0(ssat)
    W0 = randn(ddim,datadim+1); %subspace projector
    W0(:,end) = 0; % centroid from which distances are computed

    d0 = (1-ssat)/ssat;
    d = sumsq_dist(W0(:));
    W0 = sqrt(d0/median(d))*W0;
    w0 = W0(:);
    end

end


function test_this()

K = 5;
N1 = 10;
N2 = 2*N1;
data1 = randn(K,N1);
data2 = randn(K,N2);
ndx1 = [1:N1,1:N1];
ndx2 = 1:N2;

ddim = 3;
ssat = 0.99;
[sys,params] = sigmoid_log_sumsqdist([],data1,data2,ndx1,ndx2,ddim);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

dist = sigmoid_log_sumsqdist(w0,data1,data2,ndx1,ndx2,ddim),

end

