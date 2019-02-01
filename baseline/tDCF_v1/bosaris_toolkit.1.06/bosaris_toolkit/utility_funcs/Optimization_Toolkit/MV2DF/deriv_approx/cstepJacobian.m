function J = cstepJacobian(f,w)

x0=w;
y0 = f(x0);
n = length(x0);
m = length(y0);
J = zeros(m,n);
for i=1:n;
    x = x0;
    x(i) = x0(i) + 1e-20i;
    y = f(x);
    J(:,i) = 1e20*imag(y);
end
