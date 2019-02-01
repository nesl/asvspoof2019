function [y,deriv] = dottimes(w)
% This is an MV2DF
% 
%   [a; b ] --> a.*b
% 
%      where length(a) == length(b)
%

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    y = @(w) dottimes(w);
    return;
end


if isa(w,'function_handle')
    f = dottimes([]);
    y = compose_mv(f,w,[]);
    return;
end
    
w = w(:);
[a,b] = extract(w);
y = a.*b;

deriv = @(Dy) deriv_this(Dy,a,b);


function  [g,hess,linear] = deriv_this(Dy,a,b)
g = gradient(Dy,a,b);
linear = false;

hess = @(v) hess_this(v,Dy,a,b);


function [h,Jv] = hess_this(v,Dy,a,b)
[va,vb] = extract(v);
h = gradient(Dy,va,vb);
if nargout>1
  Jv = va.*b + a.*vb;
end

function [a,b] = extract(w)
h = length(w)/2;
a = w(1:h);
b = w(h+1:end);


function g = gradient(Dy,a,b)
g = [Dy.*b;Dy.*a];

function test_this()
n = 10;
a = randn(1,n);
b = randn(1,n);
w = [a(:);b(:)];

f = dottimes([]);
test_MV2DF(f,w);
