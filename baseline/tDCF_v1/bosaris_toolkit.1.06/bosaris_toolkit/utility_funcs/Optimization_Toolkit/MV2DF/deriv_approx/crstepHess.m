function H = crstepHess(f,x0,k)

if ~exist('k','var')
    k = 1;
end


e = sqrt(eps(max(x0)));

m = length(x0);
H = zeros(m);
for i=1:m
    for j=1:m

    x1 = x0; x1(i) = x1(i)+ 1e-20i; x1(j) = x1(j) + e;
    x2 = x0; x2(i) = x2(i)+ 1e-20i; x2(j) = x2(j) - e;
    y = (0.5e20/e)*imag(f(x1)-f(x2));
    H(i,j) = y(k);
    
    end
end
