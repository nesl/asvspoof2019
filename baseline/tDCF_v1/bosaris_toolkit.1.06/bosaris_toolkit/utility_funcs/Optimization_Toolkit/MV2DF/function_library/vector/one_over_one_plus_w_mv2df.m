function [y,deriv] = one_over_one_plus_w_mv2df(w)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% y = 1 ./ (1 + w)


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)one_over_one_plus_w_mv2df(w);
    return;
end

if isa(w,'function_handle')
    outer = one_over_one_plus_w_mv2df([]);
    y = compose_mv(outer,w,[]);
    return;
end



w = w(:);
y = 1 ./ (1 + w);
deriv = @(dy) deriv_this(dy,y);

function [g,hess,linear] = deriv_this(dy,y)

linear = false;
g = -dy.*(y.^2);
hess = @(d) hess_this(d,dy,y);

function [h,Jv] = hess_this(d,dy,y)

h = 2*dy.*d.*(y.^3);
if nargout>1
    Jv = -d.*(y.^2);
end


function test_this()
f = one_over_one_plus_w_mv2df([]);
test_MV2DF(f,randn(3,1));
