function [y,deriv] = linTrans(w,map,transmap)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Applies linear transform y = map(w). It needs the transpose of map, 
% transmap for computing the gradient. map and transmap are function
% handles.

if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)linTrans(w,map,transmap);
    return;
end

if isa(w,'function_handle')
    outer = linTrans([],map,transmap);
    y = compose_mv(outer,w,[]);
    return;
end

y = map(w);
y = y(:);

deriv = @(g2) deriv_this(g2,map,transmap);

function [g,hess,linear] = deriv_this(g2,map,transmap)
g = transmap(g2);
g = g(:);
%linear = false;  % use this to test linearity of map, if in doubt
linear = true;
hess = @(d) hess_this(map,d);

function [h,Jd] = hess_this(map,d)
h = [];
if nargout>1 
    Jd = map(d);
    Jd = Jd(:);
end

function test_this()
A = randn(4,5);
map = @(w) A*w;
transmap = @(y) (y.'*A).'; % faster than A'*y, if A is big
f = linTrans([],map,transmap);
test_MV2DF(f,randn(5,1));
