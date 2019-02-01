function [y,deriv] = solve_AXeqB(w,m)
% This is an MV2DF.
%
%   [A(:);B(:)] --> inv(A) * B
%



if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)solve_AXeqB(w,m);
    return;
end

if isa(w,'function_handle')
    outer = solve_AXeqB([],m);
    y = compose_mv(outer,w,[]);
    return;
end




[A,B,n] = extract(w,m);
y = A\B;
deriv = @(dy) deriv_this(dy,m,n,A,A.',y);
y = y(:);


function [g,hess,linear] = deriv_this(dy,m,n,A,At,X)
DXt = reshape(dy,m,n);
DBt = At\DXt;
DAt = -DBt*X.';
g = [DAt(:);DBt(:)];

linear = false; 
hess = @(dw) hess_this(dw,m,A,At,X,DBt);




function [h,Jv] = hess_this(dw,m,A,At,X,DBt)
[dA,dB] = extract(dw,m);

D_DBt = -(At\dA.')*DBt;
DX = A\(dB-dA*X);
D_DAt = -(D_DBt*X.'+DBt*DX.');
h = [D_DAt(:);D_DBt(:)];

if nargout>1
    Jv = A\(dB-dA*X);
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
A = randn(5); 
B = randn(5,1);
f = solve_AXeqB([],5);
test_MV2DF(f,[A(:);B(:)]);
