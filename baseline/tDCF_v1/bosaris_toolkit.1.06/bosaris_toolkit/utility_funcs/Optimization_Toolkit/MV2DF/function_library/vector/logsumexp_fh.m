function f = logsumexp_fh(m,direction,w)
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the logsumexp function. The whole mapping works like
% this, in MATLAB-style psuedocode:
%
%   F: R^(m*n) --> R^n, where y = F(x) is computed thus:
%
%   n = length(x)/m
%   If direction=1, X = reshape(x,m,n), or 
%   if direction=1, X = reshape(x,n,m). 
%   y = log(sum(exp(X),direction))
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


f = vectorized_function([],@(X)F0(X,direction),m,direction);

if exist('w','var') && ~isempty(w)
    f = f(w);
end

end

function [y,f1] = F0(X,dr)
    M = max(X,[],dr);
    y = log(sum(exp(bsxfun(@minus,X,M)),dr))+M;
    f1 = @() F1(X,y,dr);
end

function [J,f2,linear] = F1(X,y,dr)
linear = false;
J = exp(bsxfun(@minus,X,y));
f2 = @(dX) F2(dX,J,dr);
end

function H = F2(dX,J,dr)
    H = J.*bsxfun(@minus,dX,sum(dX.*J,dr));
end



function test_this()
m = 4;n = 10;
f = logsumexp_fh(m,1);
X = randn(n,m);
test_MV2DF(f,X(:));
end
