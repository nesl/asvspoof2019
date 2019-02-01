function [y,deriv] = sumsquares_penalty(w,lambda)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
% See code for details.


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)sumsquares_penalty(w,lambda);
    return;
end

if isa(w,'function_handle')
    outer = sumsquares_penalty([],lambda);
    y = compose_mv(outer,w,[]);
    return;
end



w = w(:);
if isscalar(lambda)
    lambda = lambda*ones(size(w));
else
    lambda = lambda(:);
end
    


y = 0.5*w.'*(lambda.*w);
deriv = @(dy) deriv_this(dy,lambda,lambda.*w);

function [g,hess,linear] = deriv_this(dy,lambda,lambda_w)

linear  = false;
g = dy*lambda_w;

hess = @(d) hess_this(d,dy,lambda,lambda_w);

function [h,Jv] = hess_this(d,dy,lambda,lambda_w)

h = dy*lambda.*d;
if nargout>1
    Jv = d(:).'*lambda_w;
end


function test_this()
lambda = randn(10,1);
f = sumsquares_penalty([],lambda);
test_MV2DF(f,randn(size(lambda)));
