function [y,deriv] = const_mv2df(w,const)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%  y = const(:);
%
% This wraps the given constant into an MV2DF. The output, y, is 
% independent of input w. The derivatives are sparse zero vectors of the 
% appropriate size.


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)const_mv2df(w,const);
    return;
end

if isa(w,'function_handle')
    outer = const_mv2df([],const);
    y = compose_mv(outer,w,[]);
    return;
end

w = w(:);
y = const(:);


deriv = @(g2) deriv_this(length(w),length(y));

function [g,hess,linear] = deriv_this(wsz,ysz)
g = sparse(wsz,1);
linear = true;
hess = @(d) hess_this(ysz);

function [h,Jd] = hess_this(ysz)
h = [];
if nargout>1 
    Jd = sparse(ysz,1);
end

function test_this()
A = randn(4,5);
f = const_mv2df([],A);
test_MV2DF(f,randn(5,1));
