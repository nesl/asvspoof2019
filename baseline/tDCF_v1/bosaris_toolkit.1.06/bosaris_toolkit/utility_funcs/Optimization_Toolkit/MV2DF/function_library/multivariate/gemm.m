function [prod,deriv] = gemm(w,m,k,n)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   [vec(A);vec(B)] --> vec(A*B)
%
% where 
%   A is m-by-k 
%   B is k-by-n 

if nargin==0
    test_this();
    return;
end


if isempty(w)
    prod = @(w)gemm(w,m,k,n);
    return;
end

if isa(w,'function_handle')
    outer = gemm([],m,k,n);
    prod = compose_mv(outer,w,[]);
    return;
end


w = w(:);
A = extractA(w,m,k);
B = extractB(w,m,k,n);


M = A*B;
prod = M(:);

deriv = @(g2) deriv_this(g2,A,B,m,k,n);

function [g,hess,linear] = deriv_this(g2,A,B,m,k,n)
g = vJ_this(g2,A,B,m,n);
linear = false;
hess = @(w) hess_this(m,k,n,g2,A,B,w);

function [h,Jv] = hess_this(m,k,n,g2,A,B,w)
h = vJ_this(g2,...
    extractA(w,m,k),...
    extractB(w,m,k,n),...
    m,n);
if nargout>=2
    Jv = Jv_this(w,A,B,m,k,n);
end


function prod = Jv_this(w,A,B,m,k,n)
Aw = extractA(w,m,k);
Bw = extractB(w,m,k,n);
M = Aw*B + A*Bw;
prod = M(:);

function w = vJ_this(prod,A,B,m,n)
M = reshape(prod,m,n);
Bp = A.'*M;
Ap = M*B.';
w = [Ap(:);Bp(:)];


function A = extractA(w,m,k)
A = w(1:m*k);
A = reshape(A,m,k); 



function B = extractB(w,m,k,n)
B = w(m*k+(1:k*n));
B = reshape(B,k,n);


function test_this()
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];

f = gemm([],4,5,4);
test_MV2DF(f,w);
