function f = logsigmoid_fh(w)
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the logsigmoid function. The mapping is, in 
% MATLAB-style code:
%
%   y = log(sigmoid(w)) = log(1./1+exp(-w)) = -log(1+exp(-w))
%
% Inputs: 
%   m: the number of inputs to each individual logsumexp calculation.
%   direction: 1 sums down columns, or 2 sums accross rows.
%   w: optional, if ssupplied 
%
% Outputs:
%   f: a function handle to the MV2DF described above.
%
% see: MV2DF_API_DEFINITION.readme


if nargin==0
    test_this();
    return;
end


f = vectorized_function([],@(x)F0(x));

if exist('w','var') && ~isempty(w)
    f = f(w);
end

end

function [y,f1] = F0(x)
logp1 = -neglogsigmoid(x);
logp2 = -neglogsigmoid(-x);
y = logp1;
f1 = @() F1(logp1,logp2);
end

function [J,f2,linear] = F1(logp1,logp2)
linear = false;
J = exp(logp2);
f2 = @(dx) F2(dx,logp1,logp2);
end

function h = F2(dx,logp1,logp2)
h = -dx.*exp(logp1+logp2);
end



function test_this()
n = 10;
f = logsigmoid_fh([]);
x = randn(n,1);
test_MV2DF(f,x);
end
