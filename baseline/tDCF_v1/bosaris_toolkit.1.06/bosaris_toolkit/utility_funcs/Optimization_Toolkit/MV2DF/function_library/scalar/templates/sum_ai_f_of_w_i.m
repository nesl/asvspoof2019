function [y,deriv] = sum_ai_f_of_w_i(w,a,f,b)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Does y = sum_i a_i f(w_i) + b, where f is non-linear.
%
%Notes: 
%
%  f is a function handle, with behaviour as demonstrated in the test code
%  of this function.
%
%  b is optional, defaults to 0 if omitted

if nargin==0
    test_this();
    return;
end

if ~exist('b','var')
    b = 0;
end


if isempty(w)
    y = @(w)sum_ai_f_of_w_i(w,a,f,b);
    return;
end

if isa(w,'function_handle')
    outer = sum_ai_f_of_w_i([],a,f,b);
    y = compose_mv(outer,w,[]);
    return;
end

ntot = length(a);
nz = find(a~=0);
a = a(nz);

if nargin==1
    y = f(w(nz));
else
    [y,dfdw,f2] = f(w(nz));
    deriv = @(Dy) deriv_this(Dy,dfdw.*a,f2,a,nz,ntot);
end
y = y(:);
y = a.'*y + b;


function [g,hess,linear] = deriv_this(Dy,g0,f2,a,nz,ntot)
g = zeros(ntot,1);
g(nz) = Dy*g0(:);
hess = @(d) hess_this(d,g0,f2,Dy,a,nz,ntot);
linear = false;


function [h,Jd] = hess_this(d,g0,f2,Dy,a,nz,ntot)
d = d(nz);
hnz = f2();
hnz = hnz(:).*d(:);
h = zeros(ntot,1);
h(nz) = Dy*(hnz.*a);
if nargout>1 
    Jd = g0.'*d(:);
end



function [y,ddx,f2] = test_f(x)
y = log(x);
if nargout>1
    ddx = 1./x;
    f2 = @() -1./(x.^2);
end


function test_this()
n = 10;
a = randn(n,1);
a = bsxfun(@max,a,0);
b = 5;
f = sum_ai_f_of_w_i([],a,@(x)test_f(x),b);

w = 1+rand(n,1);
test_MV2DF(f,w);
