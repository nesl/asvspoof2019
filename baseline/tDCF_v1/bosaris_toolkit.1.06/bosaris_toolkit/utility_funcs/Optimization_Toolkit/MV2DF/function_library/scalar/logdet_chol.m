function [y,deriv] = logdet_chol(w)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% y = log(det(W)), where W is positive definite and W = reshape(w,...)


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)logdet_chol(w);
    return;
end

if isa(w,'function_handle')
    outer = logdet_chol([]);
    y = compose_mv(outer,w,[]);
    return;
end

dim = sqrt(length(w));
W = reshape(w,dim,dim);

if nargout>1
    %[inv_map,bi_inv_map,logdet,iW] = invchol2(W);
    [inv_map,bi_inv_map,logdet,iW] = invchol_or_lu(W);
    y = logdet;
    deriv = @(dy) deriv_this(dy,bi_inv_map,iW);
else
    %[inv_map,bi_inv_map,logdet] = invchol2(W);
    [inv_map,bi_inv_map,logdet] = invchol_or_lu(W);
    y = logdet;
end

function [g,hess,linear] = deriv_this(dy,bi_inv_map,iW)
G = iW.';
grad = G(:);
g = dy*grad;
linear = false;
hess = @(d) hess_this(grad,bi_inv_map,dy,d);

function [h,Jd] = hess_this(grad,bi_inv_map,dy,d)
dim = sqrt(length(d));
D = reshape(d,dim,dim);
H = - dy*bi_inv_map(D).';
h = H(:);
if nargout>1 
    Jd = grad.'*d(:);
end




function test_this()
m = 3;
n = 10;

w = [];
A = UtU(w,n,m);

f = logdet_chol(A);
w = randn(m*n,1);

test_MV2DF(f,w,true);
