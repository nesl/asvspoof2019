function [prod,deriv] = mm_special(w,extractA,extractB)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   [vec(A);vec(B)] --> vec(A*B)
%
% where 
%   A is extractA(w) 
%   B is extractB(w)

if nargin==0
    test_this();
    return;
end


if isempty(w)
    prod = @(w)mm_special(w,extractA,extractB);
    return;
end

if isa(w,'function_handle')
    outer = mm_special([],extractA,extractB);
    prod = compose_mv(outer,w,[]);
    return;
end


w = w(:);
A = extractA(w);
[m,k] = size(A);

B = extractB(w);
[k2,n] = size(B);
assert(k==k2,'inner matrix dimensions must agree');

M = A*B;
prod = M(:);

deriv = @(g2) deriv_this(g2);

function [g,hess,linear] = deriv_this(g2)
g = vJ_this(g2,A,B);
linear = false;
hess = @(w) hess_this(g2,w);
end

function [h,Jv] = hess_this(g2,w)
h = vJ_this(g2,extractA(w),extractB(w));
if nargout>=2
    Jv = Jv_this(w);
end
end

function prod = Jv_this(w)
Aw = extractA(w);
Bw = extractB(w);
M = Aw*B + A*Bw;
prod = M(:);
end

function w = vJ_this(prod,A,B)
M = reshape(prod,m,n);
Bp = A.'*M;
Ap = M*B.';
w = [Ap(:);Bp(:)];
end

end

function A = extractA_this(w,m,k)
A = w(1:m*k);
A = reshape(A,m,k); 
end

function B = extractB_this(w,m,k,n)
B = w(m*k+(1:k*n));
B = reshape(B,k,n);
end

function test_this()

m = 4;
k = 5;
n = 6;

A = randn(m,k);
B = randn(k,n);

w = [A(:);B(:)];

extractA = @(w) extractA_this(w,m,k);
extractB = @(w) extractB_this(w,m,k,n);

f = mm_special([],extractA,extractB);
test_MV2DF(f,w);
end
