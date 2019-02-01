function [y,deriv] = replace_hessian(w,f,cstep)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%

if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)replace_hessian(w,f,cstep);
    return;
end

if isa(w,'function_handle')
    outer = replace_hessian([],f,cstep);
    y = compose_mv(outer,w,[]);
    return;
end


if nargout==1
    y = f(w);
else 
    [y,derivf] = f(w);
    deriv = @(dy) deriv_this(dy,derivf,f,w,cstep);
end

end

function [g,hess,linear] = deriv_this(dy,derivf,f,w,cstep)
g = derivf(dy);
if nargout>1
  linear = false;
  hess = @(dx) hess_this(dx,dy,f,w,cstep);
end
end

function [h,Jv] = hess_this(dx,dy,f,w,cstep)
if cstep
     h = cstep_approxHess(dx,dy,f,w);
else
     h = rstep_approxHess(dx,dy,f,w);
end
if nargout>1
    error('replace_hessian cannot compute Jv');
    %Jv = zeros(size(dy));
end

end


function x = rstep_approxHess(dx,dy,f,x0)
alpha = sqrt(eps);  
x2 = x0 + alpha*dx;
[dummy,deriv2] = f(x2);
x1 = x0 - alpha*dx;
[dummy,deriv1] = f(x1);
g2 = deriv2(dy);
g1 = deriv1(dy);
x = (g2-g1)/(2*alpha);
end

function p = cstep_approxHess(dx,dy,f,x0)
x = x0 + 1e-20i*dx;
[dummy,deriv] = f(x);
g = deriv(dy);
p = 1e20*imag(g);
end





function test_this()


A = randn(5); 
B = randn(5,1);

map = @(w) 5*w;
h = linTrans([],map,map);

f = solve_AXeqB([],5);
g = replace_hessian([],f,true);
g = g(h);

w = [A(:);B(:)];
test_MV2DF(g,w);


end
