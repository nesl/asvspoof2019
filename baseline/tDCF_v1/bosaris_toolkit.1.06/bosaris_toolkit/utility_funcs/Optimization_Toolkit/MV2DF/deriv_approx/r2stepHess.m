function x = r2stepHess(obj,x0,dx)
alpha = sqrt(eps);
x = x0 + alpha*dx;
[y,deriv] = obj(x);
g1 = deriv();
x = x0 - alpha*dx;
[y,deriv] = obj(x);
g2 = deriv();

x = (g1-g2)/(2*alpha);

