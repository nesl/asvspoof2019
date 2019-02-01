function J = rstepJacobian(f,w)


x0=w;
y0 = f(x0);
n = length(x0);
m = length(y0);
J = zeros(m,n);
dx = sqrt(eps);
for i=1:n;
    x = x0;
    x(i) = x0(i) + dx;
    y1 = f(x);

    x = x0;
    x(i) = x0(i) - dx;
    y0 = f(x);
    J(:,i) = (y1-y0)/(2*dx);
end
