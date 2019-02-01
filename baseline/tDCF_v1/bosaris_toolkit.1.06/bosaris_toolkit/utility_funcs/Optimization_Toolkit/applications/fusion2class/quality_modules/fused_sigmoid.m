function [ps,params] = fused_sigmoid(w,input_data)
% 
% Algorithm: ps = sigmoid( alpha'*input_data +beta)
% 
%
% Inputs:
%  w: is [alpha; beta], where alpha is D-by-1 and beta is scalar.
%     Use w=[] to let output ps be an MV2DF function handle.
%     If w is a function handle to an MV2DF then ps is the function handle
%     to the composition of w and this function. 
%
%  input_data: D-by-T matrix
%
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

[dim,n] = size(input_data);
wsz = dim+1;
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat,dim);
params.tail = wtail;

y = fusion_mv2df(whead,input_data);
ps = sigmoid_mv2df(y);

    function w0 = init_w0(ssat,dim)
    alpha = zeros(dim,1);
    beta = logit(ssat);
    w0 = [alpha;beta];
    end

end


function test_this()

K = 5;
T = 10;
data = randn(K,T);

ssat = 0.99;
[sys,params] = fused_sigmoid([],data);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

ps = fused_sigmoid(w0,data),



end
