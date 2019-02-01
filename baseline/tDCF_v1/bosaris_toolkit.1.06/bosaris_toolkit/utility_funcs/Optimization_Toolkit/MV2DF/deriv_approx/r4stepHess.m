function H = r4stepHess(f,x0,k)

if ~exist('k','var')
    k = 1;
end

e = sqrt(sqrt(eps(max(x0))));
%e = sqrt(sqrt(eps));

m = length(x0);
H = zeros(m);
for i=1:m
    for j=1:m
        x1 = x0; x1(i)= x1(i)+e; x1(j)= x1(j)+e; 
        x2 = x0; x2(i)= x2(i)+e; x2(j)= x2(j)-e; 
        x3 = x0; x3(i)= x3(i)-e; x3(j)= x3(j)+e; 
        x4 = x0; x4(i)= x4(i)-e; x4(j)= x4(j)-e; 
        y = (f(x1)-f(x2)-f(x3)+f(x4))/(4*e^2);
        H(i,j) = y(k);
    end
end
