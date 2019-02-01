function [y,deriv] = sigmoid_mv2df(w)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% y = sigmoid(w) = 1./(1+exp(-w)), vectorized as MATLAB usually does.


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)sigmoid_mv2df(w);
    return;
end

if isa(w,'function_handle')
    outer = sigmoid_mv2df([]);
    y = compose_mv(outer,w,[]);
    return;
end



w = w(:);
y = sigmoid(w);
y1 = sigmoid(-w);
deriv = @(dy) deriv_this(dy,y,y1);

function [g,hess,linear] = deriv_this(dy,y,y1)

linear  = false;
g = dy.*y.*y1;
hess = @(d) hess_this(d,dy,y,y1);

function [h,Jv] = hess_this(d,dy,y,y1)

h = dy.*d.*(y.*y1.^2 - y.^2.*y1);
if nargout>1
    Jv = d.*y.*y1;
end


function test_this()
f = sigmoid_mv2df([]);
test_MV2DF(f,randn(3,1));
