function f = scal_simple_fh(w)
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the s-calibration function. The whole mapping works like
% this, in MATLAB-style pseudocode:
%
%   If y = f([x;r;s]), where r,s are scalar, x is column vector of size m, 
%   then y is a column vector of size m and
%
%      y_i =    log( exp(x_i) + exp(r)  )   +   log( exp(-s) + 1 ) 
%             - log( exp(x_i) + exp(-s) )   -   log( exp(r)  + 1 )         
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

[x,rs] = splitvec_fh(-2);  
[r,s] = splitvec_fh(-1,rs); 

neg = @(t)-t;
negr = linTrans(r,neg,neg);
negs = linTrans(s,neg,neg);

linmap = linTrans([],@(x)map(x),@(y)transmap(y)); %add last element to others

num1 = logsumexp_special(stack([],x,r));
num2 = neglogsigmoid_fh(s);
num = linmap(stack([],num1,num2));
den1 = neglogsigmoid_fh(negr);
den2 = logsumexp_special(stack([],x,negs));
den = linmap(stack([],den2,den1));

f = sum_of_functions([],[1 -1],num,den);


if exist('w','var') && ~isempty(w)
    f = f(w);
end

end


function y = map(x)
y = x(1:end-1)+x(end);
end
function x = transmap(y)
x = [y(:);sum(y)];
end


function test_this()
n = 3;
x = randn(n,1);
r = randn(1,1);
s = randn(1,1);
X = [x;r;s];
f = scal_simple_fh([]);
test_MV2DF(f,X(:));
end
