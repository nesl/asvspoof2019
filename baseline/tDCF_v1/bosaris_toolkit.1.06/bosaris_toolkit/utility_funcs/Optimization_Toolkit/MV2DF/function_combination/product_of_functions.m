function [y,deriv] = product_of_functions(w,A,B,m,k,n)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme)
%
%   w --> vec ( reshape(A(w),m,k) * reshape(B(w),k,n) )
%
%  Here A and B are function handles to MV2DF's.



if nargin==0
    test_this();
    return;
end


if isempty(w) 
    s = stack(w,A,B);
    y = gemm(s,m,k,n);
    return;
end


if isa(w,'function_handle')
    f = product_of_functions([],A,B,m,k,n);
    y = compose_mv(f,w,[]);
    return;
end


f = product_of_functions([],A,B,m,k,n);
[y,deriv] = f(w);


function test_this()

M = 4;
N = 4;

X = [];
Xt = transpose_mv2df(X,M,N);

A = UtU(X,M,N);
B = UtU(Xt,N,M);


%A = A(randn(16,1));
%B = B(randn(16,1));

f = product_of_functions(X,A,B,4,4,4);


test_MV2DF(f,randn(16,1));
