function [sig,params] = prod_sigmoid_logdist(w,data1,data2,ndx1,ndx2,ddim)
% 
% Algorithm: sig = distribute(ndx1,sigmoid( 
%                   log( 
%                   sum(bsxfun(@minus,M*data_1,c).^2,1)
%                  )))
%                   *
%                  distribute(ndx2,sigmoid( 
%                   log( 
%                   sum(bsxfun(@minus,M*data_2,c).^2,1)
%                  )))
%                  
%
% Inputs:
%  w: is vec([M,c]), where M is ddim-by-D and c is ddim-by-1
%     Use w=[] to let output sld be an MV2DF function handle.
%
%  data_1: D-by-T1 matrix
%  data_2: D-by-T2 matrix
%  ndx1,ndx2: indices of size 1 by T to distribute T1 and T2 segs over T
%             trials
%
%  ddim: the first dimension of the M matrix
%
% Outputs:
%   sig: function handle (if w=[]), or numeric 
%   params.get_w0(ssat): returns w0 for optimization initialization, 
%                        0<ssat<1 is required average sigmoid output.
%   params.tail: is tail of parameter w, which is not consumed by this
%                function.

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

sig1 = one_over_one_plus_w_mv2df(sqd1);
sig2 = one_over_one_plus_w_mv2df(sqd2);

% distribute over trials
distrib = duplicator_fh(ndx1,size(data1,2));
sig1 = distrib(sig1);
distrib = duplicator_fh(ndx2,size(data2,2));
sig2 = distrib(sig2);

sigh = dottimes_of_functions([],sig1,sig2); 
sig = sigh(whead);


    function w0 = init_w0(ssat)
    W0 = randn(ddim,datadim+1); %subspace projector
    W0(:,end) = 0; % centroid from which distances are computed

    d0 = (1-ssat)/ssat;
    s = sigh(W0(:));
    d = (1-s)./s;
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
ssat = 0.01;
[sys,params] = prod_sigmoid_logdist([],data1,data2,ndx1,ndx2,ddim);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

sig = prod_sigmoid_logdist(w0,data1,data2,ndx1,ndx2,ddim),

end

