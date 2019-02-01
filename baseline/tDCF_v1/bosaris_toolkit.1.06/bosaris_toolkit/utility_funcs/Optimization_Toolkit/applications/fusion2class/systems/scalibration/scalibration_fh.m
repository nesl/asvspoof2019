function f = scalibration_fh(w)
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the s-calibration function. The whole mapping works like
% this, in MATLAB-style pseudocode:
%
%   If y = f([x;r;s]), where x,r,s are column vectors of size m, then y
%   is a column vector of size m and
%
%      y =    log( exp(x) + exp(r)  )   +   log( exp(-s) + 1 ) 
%           - log( exp(x) + exp(-s) )   -   log( exp(r)  + 1 )         
%
%   Viewed as a data-dependent calibration transform from x to y, with 
%   parameters r and s, then: 
%
%   r: is the log-odds that x is a typical non-target score, given that 
%      there really is a target.
%
%   s: is the log-odds that x is a typical target score, given that 
%      there really is a non-target.
%
%   Ideally r and s should be large negative, in which case this is almost 
%   an identity transform from x to y, but with saturation at large 
%   positive and negative values. Increasing r increases the lower
%   saturation level. Increasing s decreases the upper saturation level.

if nargin==0
    test_this();
    return;
end


x = columnJofN_fh(1,3);
r = columnJofN_fh(2,3);
s = columnJofN_fh(3,3);

neg = @(x)-x;
negr = linTrans(r,neg,neg);
negs = linTrans(s,neg,neg);

num1 = logsumexp_fh(2,2,stack([],x,r));
num2 = neglogsigmoid_fh(s);
den1 = neglogsigmoid_fh(negr);
den2 = logsumexp_fh(2,2,stack([],x,negs));

f = sum_of_functions([],[1 1],num1,num2);
f = sum_of_functions([],[1 -1],f,den1);
f = sum_of_functions([],[1 -1],f,den2);


if exist('w','var') && ~isempty(w)
    f = f(w);
end

end


function test_this()
n = 3;
x = randn(n,1);
r = randn(n,1);
s = randn(n,1);
X = [x;r;s];
f = scalibration_fh([]);
test_MV2DF(f,X(:));
end
