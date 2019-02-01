function [y,deriv] = square_mv2df(w)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% y = w.^2


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)square_mv2df(w);
    return;
end

if isa(w,'function_handle')
    outer = square_mv2df([]);
    y = compose_mv(outer,w,[]);
    return;
end



w = w(:);
y = w.^2;
deriv = @(dy) deriv_this(dy,w);

function [g,hess,linear] = deriv_this(dy,w)

linear  = false;
g = 2*dy.*w;
hess = @(d) hess_this(d,dy,w);

function [h,Jv] = hess_this(d,dy,w)

h = 2*dy.*d;
if nargout>1
    Jv = 2*w.*d;
end


function test_this()
f = square_mv2df([]);
test_MV2DF(f,randn(3,1));
