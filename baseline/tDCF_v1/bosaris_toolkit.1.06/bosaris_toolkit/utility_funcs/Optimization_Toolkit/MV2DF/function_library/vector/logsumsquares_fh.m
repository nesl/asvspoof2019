function f = logsumsquares_fh(m,direction,w)
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the logsumsquares function. The whole mapping works like
% this, in MATLAB-style psuedocode:
%
%   F: R^(m*n) --> R^n, where y = F(x) is computed thus:
%
%   n = length(x)/m
%   If direction=1, X = reshape(x,m,n), or 
%   if direction=1, X = reshape(x,n,m). 
%   y = log(sum(X.^2,direction))
%
% Inputs: 
%   m: the number of inputs to each individual logsumexp calculation.
%   direction: 1 sums down columns, or 2 sums accross rows.
%
%
% Outputs:
%   f: a function handle to the MV2DF described above.
%
% see: MV2DF_API_DEFINITION.readme


if nargin==0
    test_this();
    return;
end


f = vectorized_function([],@(X)F0(X,direction),m,direction);

if exist('w','var') && ~isempty(w)
    f = f(w);
end

end

function [y,f1] = F0(X,dr)
    ssq = sum(X.^2,dr);
    y = log(ssq);
    f1 = @() F1(X,ssq,dr);
end

function [J,f2,linear] = F1(X,s,dr)
linear = false;
J = bsxfun(@times,X,2./s);
f2 = @(dX) F2(dX,X,s,dr);
end

function H = F2(dX,X,s,dr)
    H = bsxfun(@times,dX,2./s) - bsxfun(@times,X,4*sum(X.*dX,dr)./(s.^2));
end



function test_this()
m = 4;n = 10;
f = logsumsquares_fh(m,1);
X = randn(n,m);
test_MV2DF(f,X(:));
end
