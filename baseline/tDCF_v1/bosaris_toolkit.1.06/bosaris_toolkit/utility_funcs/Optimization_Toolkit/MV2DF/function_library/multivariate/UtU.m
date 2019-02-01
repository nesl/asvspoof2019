function [prod,deriv] = UtU(w,m,n)
% This is a MV2DF. See MV2DF_API_DEFINITION.readme.
% U = reshape(w,m,n), M = U'*U, prod = M(:).


if nargin==0
    test_this();
    return;
end


if isempty(w)
    prod = @(w)UtU(w,m,n);
    return;
end

if isa(w,'function_handle')
    outer = UtU([],m,n);
    prod = compose_mv(outer,w,[]);
    return;
end



w = w(:);
U = reshape(w,m,n);

M = U.'*U;
prod = M(:);

deriv = @(g2) deriv_this(g2,U,m,n);

function [g,hess,linear] = deriv_this(g2,U,m,n)
g = vJ_this(g2,U,n);
linear = false;
hess = @(w) hess_this(w,g2,U,m,n);

function [h,Jv] = hess_this(w,g2,U,m,n)
h = vJ_this(g2,reshape(w,m,n),n);
if nargout>=2
    Jv = Jv_this(w,U,m,n);
end

function dy = Jv_this(dw,U,m,n)
dU = reshape(dw,m,n);
dM = U.'*dU;
dM = dM+dM.';
dy = dM(:);

function w = vJ_this(dy,U,n)
dY = reshape(dy,n,n);
dU = U*(dY+dY.');
w = dU(:);


function test_this()
m = 5;
n = 3;
f = UtU([],m,n);
U = randn(m,n);
test_MV2DF(f,U(:));
