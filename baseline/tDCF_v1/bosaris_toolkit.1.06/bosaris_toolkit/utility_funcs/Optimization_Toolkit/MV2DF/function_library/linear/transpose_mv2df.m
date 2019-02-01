function [y,deriv] = transpose_mv2df(w,M,N)
% This is an MV2DF . See MV2DF_API_DEFINITION.readme.
% 
%  vec(A) --> vec(A'), 
%
% where A is M by N
%
% Note: this is an orthogonal linear transform.

if nargin==0
    test_this();
    return;
end


if isempty(w) 
    map = @(w) reshape(reshape(w,M,N).',[],1);
    transmap = @(w) reshape(reshape(w,N,M).',[],1);
    y = linTrans(w,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = transpose_mv2df([],M,N);
    y = compose_mv(f,w,[]);
    return;
end

f = transpose_mv2df([],M,N);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end

function test_this()

M = 4;
N = 5;
f = transpose_mv2df([],M,N);
test_MV2DF(f,randn(M*N,1));
