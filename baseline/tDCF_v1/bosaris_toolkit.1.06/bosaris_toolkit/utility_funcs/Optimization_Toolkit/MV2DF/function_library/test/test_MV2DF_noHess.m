function test_MV2DF_noHess(f,x0)

%id_in = identity_trans([]);
%id_out = identity_trans([]);
%f = f(id_in);
%f = id_out(f);

x0 = x0(:);

Jc = cstepJacobian(f,x0);
Jr = rstepJacobian(f,x0);

[y0,deriv] = f(x0);
m = length(y0);
n = length(x0);

J2 = zeros(size(Jr));
for i=1:m;
    y = zeros(m,1);
    y(i) = 1;
    J2(i,:) = deriv(y)';
end
c_err = max(max(abs(Jc-J2)));
r_err = max(max(abs(Jr-J2)));
fprintf('test gradient : cstep err = %g, rstep err = %g\n',c_err,r_err);

g2 = randn(m,1);

rHess = @(dx) rstep_approxHess(dx,g2,f,x0);
cHess = @(dx) cstep_approxHess(dx,g2,f,x0);

Hr = zeros(n,n);
Hc = zeros(n,n);
for j=1:n;
    x = zeros(n,1);
    x(j) = 1;
    Hr(:,j) = rHess(x);
    Hc(:,j) = cHess(x);
end

rc_err = max(max(abs(Hr-Hc)));
fprintf('test Hess prod: cstep-rstep = %g\n',rc_err);

function x = rstep_approxHess(dx,dy,f,x0)
alpha = sqrt(eps);  
x2 = x0 + alpha*dx;
[dummy,deriv2] = f(x2);
x1 = x0 - alpha*dx;
[dummy,deriv1] = f(x1);
g2 = deriv2(dy);
g1 = deriv1(dy);
x = (g2-g1)/(2*alpha);

function p = cstep_approxHess(dx,dy,f,x0)
x = x0 + 1e-20i*dx;
[dummy,deriv] = f(x);
g = deriv(dy);
p = 1e20*imag(g);
