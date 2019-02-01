function [y,deriv] = XtKX(w,K)
%This is an MV2DF.
%
%  vec(X) --> vec(X'KX)
%

if nargin==0
    test_this();
    return;
end

m = size(K,1);


if isempty(w)
    y = @(w) XtKX(w,K);
    return;
end


if isa(w,'function_handle')
    outer = XtKX([],K);
    y = compose_mv(outer,w,[]);
    return;
end

X = reshape(w,m,[]);
n = size(X,2);
y = X.'*K*X;

y = y(:);

deriv = @(dy) deriv_this(dy,K,X,n);

function [g,hess,linear] = deriv_this(DY,K,X,n)
linear = false;  
DY = reshape(DY,n,n).';
g = DY.'*X.'*K.' + DY*X.'*K;
g = g.';
g = g(:);

hess = @(dx) hess_this(dx,K,X,DY);




function [h,Jv] = hess_this(DX,K,X,DY)
m = size(K,1);
DX = reshape(DX,m,[]);
h = K*DX*DY + K.'*DX*DY.';
h = h(:);


if nargin<2
    return;
end

Jv = DX.'*K*X + X.'*K*DX;
Jv = Jv(:);



function test_this()
K = randn(4);
X = randn(4,3);
f = XtKX([],K);
test_MV2DF(f,X(:));
