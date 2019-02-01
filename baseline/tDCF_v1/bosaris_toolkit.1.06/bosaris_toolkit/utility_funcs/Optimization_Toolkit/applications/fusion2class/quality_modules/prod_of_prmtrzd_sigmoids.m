function [ps,params] = prod_of_prmtrzd_sigmoids(w,input_data)
% 
% Algorithm: ps = prod_i sigmoid( alpha_i*input_data(i,:) + beta_i)
% 
%
% Inputs:
%  w: is vec([alpha; beta]), where alpha and beta are 1-by-D.
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
prms = cell(1,m);

[ps,prms{1}] = prmtrzd_sigmoid([],input_data(1,:));
for i=2:m
    [ps2,prms{i}] = prmtrzd_sigmoid(prms{i-1}.tail,input_data(i,:));
    ps = dottimes_of_functions([],ps,ps2);
end

if ~isempty(w)
    ps = ps(w);
end

params.get_w0 = @(ssat) init_w0(ssat,m);
params.tail = prms{m}.tail;


    function w0 = init_w0(ssat,m)
    ssat = ssat^(1/m);
    w0 = zeros(m*2,1);
    at = 1;
    for j=1:m
        w0(at:at+1) = prms{j}.get_w0(ssat);
        at = at + 2;    
    end
    end

end


function test_this()

K = 3;
T = 10;
data = randn(K,T);

ssat = 0.99;
[sys,params] = prod_of_prmtrzd_sigmoids([],data);

w0 = params.get_w0(ssat);
test_MV2DF(sys,w0);

ps = prod_of_prmtrzd_sigmoids(w0,data),

end
