function [y,deriv] = affineTrans(w,affineMap,linMap,transMap)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Applies affine transform y = affineMap(w). It needs also needs
% linMap, the linear part of the mapping, as well as transMap, the 
% transpose of linMap. All of affineMap, linMap and transMap are function
% handles.
%
% Note, linMap(x) =  J*x where J is the Jacobian of affineMap; and
% transMap(y) = J'y.

if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)affineTrans(w,affineMap,linMap,transMap);
    return;
end

if isa(w,'function_handle')
    outer = affineTrans([],affineMap,linMap,transMap);
    y = compose_mv(outer,w,[]);
    return;
end

y = affineMap(w);
y = y(:);

deriv = @(g2) deriv_this(g2,linMap,transMap);

function [g,hess,linear] = deriv_this(g2,linMap,transMap)
g = transMap(g2);
g = g(:);
%linear = false;  % use this to test linearity of affineMap, if in doubt
linear = true;
hess = @(d) hess_this(linMap,d);

function [h,Jd] = hess_this(linMap,d)
%h=zeros(size(d)); % use this to test linearity of affineMap, if in doubt
h = [];
if nargout>1
    Jd = linMap(d);
    Jd = Jd(:);
end


function test_this()
A = randn(4,5);
k = randn(4,1);
affineMap = @(w) A*w+k;
linMap = @(w) A*w;
transMap = @(y) (y.'*A).'; % faster than A'*y, if A is big
f = affineTrans([],affineMap,linMap,transMap);
test_MV2DF(f,randn(5,1));
