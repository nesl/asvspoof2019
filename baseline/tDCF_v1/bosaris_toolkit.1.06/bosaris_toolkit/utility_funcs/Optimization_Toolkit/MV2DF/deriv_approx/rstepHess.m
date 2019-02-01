function x = rstepHess(obj,x0,dx,grad0)
alpha = sqrt(eps);
x = x0 + alpha*dx;
[y,deriv] = obj(x);
g = deriv();
x = (g-grad0)/alpha;

