function [y,deriv] = KtimesW(w,K)
% This is an MV2DF . See MV2DF_API_DEFINITION.readme.
% 
%  
%


if nargin==0
    test_this();
    return;
end


if isempty(w) 
    map = @(w) map_this(w,K);
    transmap = @(y) transmap_this(y,K);
    y = linTrans(w,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = KtimesW([],K);
    y = compose_mv(f,w,[]);
    return;
end

f = KtimesW([],K);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function y = map_this(w,K)
[m,n] = size(K);
y = K*reshape(w,n,[]);
y = y(:);

function w = transmap_this(y,K)
[m,n] = size(K);
w = K.'*reshape(y,m,[]);

function test_this()
m = 3;
n = 4;
K = randn(m,n);
r = 2;
W = randn(n,r);
f = KtimesW([],K);
test_MV2DF(f,W(:));
