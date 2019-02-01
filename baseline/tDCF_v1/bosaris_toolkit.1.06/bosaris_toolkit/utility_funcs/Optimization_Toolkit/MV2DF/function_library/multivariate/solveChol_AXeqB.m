function [y,deriv] = solveChol_AXeqB(w,m)
% This is an MV2DF.
%
%   [A(:);B(:)] --> inv(A) * B
%
% We assume A is positive definite and we solve using Choleski


if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)solveChol_AXeqB(w,m);
    return;
end

if isa(w,'function_handle')
    outer = solveChol_AXeqB([],m);
    y = compose_mv(outer,w,[]);
    return;
end




[A,B,n] = extract(w,m);
if isreal(A)
    R = chol(A);
    solve = @(B) R\(R.'\B);
else %complex
    solve = @(B) A\B;
end
y = solve(B);
deriv = @(dy) deriv_this(dy,m,n,solve,y);
y = y(:);


function [g,hess,linear] = deriv_this(dy,m,n,solve,X)
DXt = reshape(dy,m,n);
DBt = solve(DXt);
DAt = -DBt*X.';
g = [DAt(:);DBt(:)];

linear = false; 
hess = @(dw) hess_this(dw,m,solve,X,DBt);




function [h,Jv] = hess_this(dw,m,solve,X,DBt)
[dA,dB] = extract(dw,m);

D_DBt = -solve(dA.'*DBt);
DX = solve(dB-dA*X);
D_DAt = -(D_DBt*X.'+DBt*DX.');
h = [D_DAt(:);D_DBt(:)];

if nargout>1
    Jv = solve(dB-dA*X);
    Jv = Jv(:);
end



function [A,B,n] = extract(w,m)
mm = m^2;
A = w(1:mm);
A = reshape(A,m,m);
B = w(mm+1:end);
B = reshape(B,m,[]);
n = size(B,2);



function test_this()
m = 3;
n = 10;
k = 8;
Usz = m*n;
Bsz = m*k;
Wsz = Usz+Bsz;

w = [];
U = subvec(w,Wsz,1,Usz);
B = subvec(w,Wsz,Usz+1,Bsz);
A = UtU(U,n,m);
AB = stack(w,A,B);

f = solveChol_AXeqB(AB,m);
w = randn(Wsz,1);

test_MV2DF(f,w,true);
