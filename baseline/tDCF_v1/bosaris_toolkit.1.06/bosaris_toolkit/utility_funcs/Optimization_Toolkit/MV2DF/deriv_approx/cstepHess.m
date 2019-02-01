function x = cstepHess(obj,x0,dx)
%Approximates H * dx, where H is Hessian of obj at x0.
%  obj must supply gradient, which is then differentiated with complex step
%  method.
%
% Note: 
% -- gradient implementation must not use any complex arithmetic, but
%    must be able to accept complex arguments. 
% -- gradient implementation should use .' transpose, not conjugate
%    transpose '

x = x0 + 1e-20i*dx;
[y,deriv] = obj(x);
g = deriv();
x = 1e20*imag(g);
