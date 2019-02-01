function [ps,params] = prmtrzd_sigmoid(w,input_data)
% 
% Algorithm: ps = sigmoid( w0+w1'*input_data ), where 
%    w = [w1;w0]; w0 is scalar; and w1 is vector
% 
%
% Inputs:
%  w = [w1;w0]; w0 is scalar; and w1 is vector.
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

m = size(input_data,1);
wsz = m+1;
[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(ssat) init_w0(ssat);
params.tail = wtail;

y = fusion_mv2df(whead,input_data);
ps = sigmoid_mv2df(y);

    function w0 = init_w0(ssat)
    w0 = zeros(wsz,1);
    offs = logit(ssat);
    w0(end) = offs;
    end

end


function test_this()

D = 3;
K = 5;
data = randn(D,K);

ssat = 0.99;
[sys,params] = prmtrzd_sigmoid([],data);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

ps = prmtrzd_sigmoid(w0,data),



end
