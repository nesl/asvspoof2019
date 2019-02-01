function [y,deriv] = bsxtimes(w,m,n)
% This is an MV2DF
% 
% w = [vec(A); vec(b) ] --> vec(bsxfun(@times,A,b)), 
% 
%      where A is an m-by-n matrix and 
%            b is a 1-by-n row.
%

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    y = @(w) bsxtimes(w,m,n);
    return;
end


if isa(w,'function_handle')
    f = bsxtimes([],m,n);
    y = compose_mv(f,w,[]);
    return;
end
    
[A,b] = extract(w,m,n);
y = bsxfun(@times,A,b);
y = y(:);

deriv = @(Dy) deriv_this(Dy,A,b);


function  [g,hess,linear] = deriv_this(Dy,A,b)
g = gradient(Dy,A,b);
linear = false;

hess = @(v) hess_this(v,Dy,A,b);


function [h,Jv] = hess_this(v,Dy,A,b)
[m,n] = size(A);
[vA,vb] = extract(v,m,n);
h = gradient(Dy,vA,vb);
if nargout>1
  Jv = bsxfun(@times,vA,b);
  Jv = Jv + bsxfun(@times,A,vb);
  Jv = Jv(:);
end

function [A,b] = extract(w,m,n)
A = reshape(w(1:m*n),m,n);
b = w(m*n+1:end).';

function g = gradient(Dy,A,b)
Dy = reshape(Dy,size(A));
gA = bsxfun(@times,Dy,b);
gb = sum(Dy.*A,1);
g = [gA(:);gb(:)];

function test_this()
m = 5;
n = 10;
A = randn(m,n);
b = randn(1,n);
w = [A(:);b(:)];

f = bsxtimes([],m,n);
test_MV2DF(f,w);
