function [y,deriv] = sqdist(w,dim)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% If W = reshape(w,dim,n), then Y = vec of symmetric n-by-n matrix of 
% 1/2 squared euclidian distances between all columns of W.


if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)sqdist(w,dim);
    return;
end

if isa(w,'function_handle')
    outer = sqdist([],dim);
    y = compose_mv(outer,w,[]);
    return;
end

X = reshape(w,dim,[]);
N = size(X,2);
XX = 0.5*sum(X.^2,1);
y = bsxfun(@minus,XX.',X.'*X);
y = bsxfun(@plus,y,XX);
y = y(:);


deriv = @(dy) deriv_this(dy,X,N);

function [G,hess,linear] = deriv_this(DY,X,N)
DY = reshape(DY,N,N);
sumDY = sum(DY,1)+sum(DY,2).';
DYDY = DY+DY.';
G = bsxfun(@times,X,sumDY)-X*DYDY;
G = G(:);
linear = false;
hess = @(d) hess_this(d,DYDY,sumDY,X);

function [H,Jv] = hess_this(D,DYDY,sumDY,X)
D = reshape(D,size(X));
H = bsxfun(@times,D,sumDY)-D*DYDY;
H = H(:);
if nargout>=2
    DtX = D.'*X;
    xd = sum(X.*D,1);
    Jv = bsxfun(@minus,xd,DtX + DtX.');
    Jv = bsxfun(@plus,Jv,xd.');
    Jv = Jv(:);
end



function test_this()
dim = 4;
X = randn(dim,5);

w = X(:);

f = sqdist([],dim);
test_MV2DF(f,w);
