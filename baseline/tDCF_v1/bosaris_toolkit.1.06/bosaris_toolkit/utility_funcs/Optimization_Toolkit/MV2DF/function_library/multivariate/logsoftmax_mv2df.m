function [y,deriv] = logsoftmax_mv2df(w,m)
% This is a MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Does:
% (i) Reshapes w to m-by-n. 
% (ii) Computes logsoftmax of each of n columns. 


if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)logsoftmax_mv2df(w,m);
    return;
end

if isa(w,'function_handle')
    outer = logsoftmax_mv2df([],m);
    y = compose_mv(outer,w,[]);
    return;
end



w = reshape(w,m,[]);
y = logsoftmax(w);

if nargout>1
    deriv = @(Dy) deriv_this(Dy,exp(y));
end

y = y(:);


function [g,hess,linear] = deriv_this(Dy,smax)
[m,n] = size(smax);
Dy = reshape(Dy,m,n);
sumDy = sum(Dy,1);
g = Dy - bsxfun(@times,smax,sumDy);
g = g(:); 

linear = false; 
hess = @(v) hess_this(v,sumDy,smax);


function [h,Jv] = hess_this(V,sumDy,smax)
[m,n] = size(smax);
V = reshape(V,m,n);
Vsmax = V.*smax;
sumVsmax = sum(Vsmax,1);
h = bsxfun(@times,smax,sumVsmax) - Vsmax;
h = bsxfun(@times,h,sumDy);
h = h(:);
if nargout>1
  Jv = bsxfun(@minus,V,sumVsmax);
  Jv = Jv(:);
end


function test_this()
m = 10;
n = 3;

%A = randn(m);
%map = @(x) reshape(A*reshape(x,m,[]),[],1);
%transmap = @(y) reshape(A'*reshape(y,m,[]),[],1);
%f = linTrans([],map,transmap);


f = logsoftmax_mv2df([],m);
test_MV2DF(f,randn(m*n,1));
