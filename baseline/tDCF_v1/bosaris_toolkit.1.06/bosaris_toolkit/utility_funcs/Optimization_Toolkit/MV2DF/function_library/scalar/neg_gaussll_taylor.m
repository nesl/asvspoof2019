function [y,deriv] = neg_gaussll_taylor(w,x)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% This function represents the part of log N(x|0,W) that is dependent on 
%   W = reshape(w,...), where w is variable and x is given. 
%
% y = -0.5*x'*inv(W)*x - 0.5*log(det(W)), where W is positive definite and W = reshape(w,...)


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)neg_gaussll_taylor(w,x);
    return;
end

if isa(w,'function_handle')
    outer = neg_gaussll_taylor([],x);
    y = compose_mv(outer,w,[]);
    return;
end

dim = length(x);
W = reshape(w,dim,dim);

[inv_map,logdet] = invchol_taylor(W);
z = inv_map(x);
y = 0.5*x'*z + 0.5*logdet;
deriv = @(dy) deriv_this(dy,z,inv_map);

end

function [g,hess,linear] = deriv_this(dy,z,inv_map)
G1 = z*z.';
G2 = inv_map(eye(length(z)));
grad = 0.5*(G2(:)-G1(:));
g = dy*grad;
linear = false;
hess = @(d) hess_this(grad,z,inv_map,dy,d);
end


function [h,Jd] = hess_this(grad,z,inv_map,dy,d)
dim = sqrt(length(d));
D = reshape(d,dim,dim);
H1 = inv_map(D*z)*z' + z*inv_map(D'*z)';
H2 = inv_map(inv_map(D)');
h = 0.5*dy*(H1(:)-H2(:));
if nargout>1 
    Jd =  grad.'*d(:);
end
end



function test_this()
m = 3;
n = 10;

w = [];
A = UtU(w,n,m); %A is m-by-m
x = randn(m,1);

f = neg_gaussll_taylor(A,x);
w = randn(m*n,1);

test_MV2DF(f,w,true);
end
