function [y,deriv] = expneg_mv2df(w)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% y = exp(-w), vectorized as MATLAB usually does.


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)expneg_mv2df(w);
    return;
end

if isa(w,'function_handle')
    outer = expneg_mv2df([]);
    y = compose_mv(outer,w,[]);
    return;
end



w = w(:);
y = exp(-w);
deriv = @(dy) deriv_this(dy,y);

function [g,hess,linear] = deriv_this(dy,y)

linear  = false;
g = -dy.*y;
hess = @(d) hess_this(d,dy,y);

function [h,Jv] = hess_this(d,dy,y)

h = dy.*y.*d;
if nargout>1
    Jv = -d.*y;
end


function test_this()
f = expneg_mv2df([]);
test_MV2DF(f,randn(3,1));
