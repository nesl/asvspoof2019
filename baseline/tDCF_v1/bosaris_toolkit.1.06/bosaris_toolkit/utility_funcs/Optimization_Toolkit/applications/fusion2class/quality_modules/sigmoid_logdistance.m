    function [sld,params] = sigmoid_logdistance(w,input_data,ddim)
% 
% Algorithm: sld = sigmoid( 
%                   log( 
%                   sum(bsxfun(@minus,M*input_data,c).^2,1)
%                  ))
% 
%
% Inputs:
%  w: is vec([M,c]), where M is ddim-by-D and c is ddim-by-1
%     Use w=[] to let output sld be an MV2DF function handle.
%
%  input_data: D-by-T matrix
%
%  ddim: the first dimension of the W matrix given as the first
%       parameter to run_sys
%
% Outputs:
%   sld: function handle (if w=[]), or numeric 
%   params.get_w0(ssat): returns w0 for optimization initialization, 
%                        0<ssat<1 is required average sigmoid output.
%   params.tail: is tail of parameter w, which is not consumed by this
%                function.

if nargin==0
    test_this();
    return;
end

datadim = size(input_data,1);
wsz = ddim*(datadim+1);
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat);
params.tail = wtail;


dist = square_distance_mv2df(whead,input_data,ddim);
sld = one_over_one_plus_w_mv2df(dist);


    function w0 = init_w0(ssat)
    W0 = randn(ddim,datadim+1);
    W0(:,end) = 0; % centroid from which distances are computed

    d0 = (1-ssat)/ssat;
    d = square_distance_mv2df(W0(:),input_data,ddim);
    W0 = sqrt(d0/median(d))*W0;
    w0 = W0(:);
    end

end


function test_this()

K = 5;
N = 10;
data = randn(N,K);

ddim = 3;
ssat = 0.99;
[sys,params] = sigmoid_logdistance([],data,ddim);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

dist = sigmoid_logdistance(w0,data,ddim),



end
