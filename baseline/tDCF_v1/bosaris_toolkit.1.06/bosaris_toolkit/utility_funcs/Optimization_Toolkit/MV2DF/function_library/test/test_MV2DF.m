function test_MV2DF(f,x0,do_cstep)

%id_in = identity_trans([]);
%id_out = identity_trans([]);
%f = f(id_in);
%f = id_out(f);

x0 = x0(:);

if ~exist('do_cstep','var')
    do_cstep = 1;
end

if do_cstep
    Jc = cstepJacobian(f,x0);
end
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
if do_cstep
    c_err = max(max(abs(Jc-J2)));
else
    c_err = nan;
end
r_err = max(max(abs(Jr-J2)));
fprintf('test gradient : cstep err = %g, rstep err = %g\n',c_err,r_err);

g2 = randn(m,1);
[dummy,hess,linear] = deriv(g2);


if true %~linear
    rHess = @(dx) rstep_approxHess(dx,g2,f,x0);
    if do_cstep
        cHess = @(dx) cstep_approxHess(dx,g2,f,x0);
    else
        cHess = @(dx) nan(size(dx));
    end
end


J1 = zeros(size(Jr));
if true %~linear
    H1 = zeros(n,n);
    H2 = zeros(n,n);
    Hr = zeros(n,n);
    Hc = zeros(n,n);
end
for j=1:n;
    x = zeros(n,1);
    x(j) = 1;
    [h1,jx] = hess(x);  
    h2 = hess(x);  
    J1(:,j) = jx;
    if ~linear
        H1(:,j) = h1;
        H2(:,j) = h2;
    end
    Hr(:,j) = rHess(x);
    Hc(:,j) = cHess(x);
end

if do_cstep
    c_err = max(max(abs(Jc-J1)));
else
    c_err = nan;
end
r_err = max(max(abs(Jr-J1)));
fprintf('test Jacobian : cstep err = %g, rstep err = %g\n',c_err,r_err);



fprintf('test Jacobian-gradient'': %g\n',max(max(abs(J1-J2))));

if false %linear
    fprintf('function claims to be linear, not testing Hessians\n');
    return;
end



r_err = max(max(abs(H1-Hr)));
c_err = max(max(abs(H1-Hc)));
rc_err = max(max(abs(Hr-Hc)));

fprintf('test Hess prod: cstep err = %g, rstep err = %g, cstep-rstep = %g\n',c_err,r_err,rc_err);
fprintf('test H1-H2: %g\n',max(max(abs(H1-H2))));

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
