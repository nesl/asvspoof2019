function [ps,params] = prmtrzd_sig_log_dist(w,input_data,ddim)
% 
% Algorithm: ps = sigmoid( 
%                   offs+scal*log( 
%                   sum(bsxfun(@minus,M*input_data,c).^2,1)
%                  ))
% 
%
% Inputs:
%  w: is [ vec(M); c; scal; offs], where M is ddim-by-D; c is ddim-by-1;
%     and scal and offs are scalar.
%     Use w=[] to let output ps be an MV2DF function handle.
%     If w is a function handle to an MV2DF then ps is the function handle
%     to the composition of w and this function. 
%
%  input_data: D-by-T matrix
%
%  ddim: the first dimension of the M matrix
%
% Outputs:
%   ps: function handle (if w=[], or w is handle), or numeric T-by-1
%   params.get_w0(ssat): returns w0 for optimization initialization, 
%                        0<ssat<1 is required average sigmoid output.
%   params.tail: is tail of parameter w, which is not consumed by this
%                function.

if nargin==0
    test_this();
    return;
end

[datadim,n] = size(input_data);
Mc_sz = ddim*(datadim+1);
wsz = Mc_sz + 2;
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat);
params.tail = wtail;

[M_c,scal_offs] = splitvec_fh(Mc_sz,w); 
ld = log_distance_mv2df(M_c,input_data,ddim);
tld = scale_and_translate(w,ld,scal_offs,1,n);
ps = sigmoid_mv2df(tld);

    function w0 = init_w0(ssat)
    M = randn(ddim,datadim);
    c = zeros(ddim,1); 
    scal = 1;
    offs = 0;
    w0 = [M(:);c;scal;offs];
    x = ld(w0);
    y = logit(ssat);
    scal = y/median(x);
    w0(end-1) = scal;
    end

end


function test_this()

K = 5;
N = 10;
data = randn(N,K);

ddim = 3;
ssat = 0.99;
[sys,params] = prmtrzd_sig_log_dist([],data,ddim);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

ps = prmtrzd_sig_log_dist(w0,data,ddim),



end
