function [y,deriv] = addOffset(w,K,N)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   w = [vec(A);b] --> vec(bsxfun(@plus,A,b))
%
%   This function retrieves a K by N matrix as well as a K-vector from w, 
%   adds the K-vector to every column of the matrix
%   and outputs the vectorized result.
%   Note this is a linear transform.


if nargin==0
    test_this();
    return;
end

if isempty(w) 
    map = @(w) map_this(w,K,N);
    transmap = @(w) transmap_this(w,K,N);
    y = linTrans(w,map,transmap);
    return;
end

if isa(w,'function_handle')
    f = addOffset([],K,N);
    y = compose_mv(f,w,[]);
    return;
end


f = addOffset([],K,N);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end




function y = map_this(w,K,N)
y = w(1:K*N);
y = reshape(y,K,N);
offs = w((K*N+1):end);
y = bsxfun(@plus,y,offs(:));
y = y(:);


function y = transmap_this(x,K,N)
M = reshape(x,K,N);
y = [x(1:K*N);sum(M,2)];


function test_this()
K = 5;
N = 10;
M = randn(K,N);
offs = randn(K,1);
w = [M(:);offs];

f = addOffset([],K,N);
test_MV2DF(f,w);
