function [y,deriv] = dottimes_of_functions(w,A,B)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme)
%
%   w --> A(w) .* B(w)
%
%  Here A and B are function handles to MV2DF's.



if nargin==0
    test_this();
    return;
end



if isempty(w) 
    s = stack(w,A,B);
    y = dottimes(s);
    return;
end


if isa(w,'function_handle')
    f = dottimes_of_functions([],A,B);
    y = compose_mv(f,w,[]);
    return;
end


f = dottimes_of_functions([],A,B);
[y,deriv] = f(w);


function test_this()

M = 4;

X = [];
Xt = transpose_mv2df(X,M,M);

A = UtU(X,M,M);
B = UtU(Xt,M,M);


f = dottimes_of_functions(X,A,B);


test_MV2DF(f,randn(16,1));
