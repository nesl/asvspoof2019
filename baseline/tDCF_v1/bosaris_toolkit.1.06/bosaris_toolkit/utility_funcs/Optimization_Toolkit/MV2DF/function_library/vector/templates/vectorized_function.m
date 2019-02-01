function [y,deriv] = vectorized_function(w,f,m,direction)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% This template vectorizes the given function F: R^m -> R as follows:
%   k = length(w)/m;
%   If direction=1, X = reshape(w,m,k), y(j) = F(X(:,j)), or
%   if direction=2, X = reshape(w,k,m), y(i) = F(X(i,:)),
%   so that length(y) = k.
% 
% Input parameters:
%   w: As with every MV2DF, w can be [], a vector, or a function handle to
%      another MV2DF.
%   f: is a function handle to an m-file that represents the function 
%      F: R^m -> R, as well as its first and second derivatives.
%
%   m: The input dimension to F. 
%      (optional, default m = 1)
%
%   direction: is used as explained above to determine whether columns,
%              or rows of X are processed by F. 
%              (optional, default  direction = 2)
%
%   Function f works as follows: 
%     (Note that f, f1 and f2 have to know the required direction, it is 
%      not passed to them.)
%   [y,f1] = f(X), where X and y are as defined above.
%
%   Function f1 works as follows:
%   [J,f2] = f1(), where size(J) = size(X). 
%                  Column/row i of J is the gradient of y(i) w.r.t. 
%                  column/row i of W.
%                  f2 is a function handle to 2nd order derivatives. 
%                     If 2nd order derivatives are 0, then f2 should be [].
%
%   Function f2 works as follows:
%   H = f2(dX), where size(dX) = size(X). 
%               If direction=1, H(:,j) = H_i * dX(:,j), or
%               if direction=2, H(i,:) = dX(i,:)* H_i, where 
%               H_i is Hessian of y(i), w.r.t. colum/row i of X.
%
%




if nargin==0
    test_this();
    return;
end

if ~exist('m','var')
    m = 1;
    direction = 2;
end


if isempty(w)
    y = @(w)vectorized_function(w,f,m,direction);
    return;
end

if isa(w,'function_handle')
    outer = vectorized_function([],f,m,direction);
    y = compose_mv(outer,w,[]);
    return;
end



if direction==1
    W = reshape(w,m,[]);
elseif direction==2
    W = reshape(w,[],m);
else
    error('illegal direction %i',direction);
end

if nargout==1
    y = f(W);
else 
    [y,f1] = f(W);
    deriv = @(dy) deriv_this(dy,f1,direction);
end
y = y(:);

end

function [g,hess,linear] = deriv_this(dy,f1,direction)
if direction==1
    dy = dy(:).';
else
    dy = dy(:);
end
if nargout==1
  J = f1();
  g = reshape(bsxfun(@times,J,dy),[],1);
else
  [J,f2] = f1();
  linear = isempty(f2);
  g = reshape(bsxfun(@times,J,dy),[],1);
  hess = @(d) hess_this(d,f2,J,dy,direction);
end


end

function [h,Jv] = hess_this(dx,f2,J,dy,direction)

dX = reshape(dx,size(J));
if isempty(f2)
    h = [];
else
    h = reshape(bsxfun(@times,dy,f2(dX)),[],1);
end
if nargout>1
    Jv = sum(dX.*J,direction);
    Jv = Jv(:);
end

end

%%%%%%%%%%%%%%%%%%%%  Example function: z = x^2 + y^3 %%%%%%%%%%%%%%%%%%%%

% example function: z = x^2 + y^3
function [z,f1] = x2y3(X,direction)
    if direction==1
        x = X(1,:);
        y = X(2,:);
    else
        x = X(:,1);
        y = X(:,2);
    end
    z = x.^2+y.^3;
    f1 = @() f1_x2y3(x,y,direction);
end

% example function 1st derivative: z = x^2 + y^2
function [J,f2] = f1_x2y3(x,y,direction)
if direction==1
    J = [2*x;3*y.^2];
else
    J = [2*x,3*y.^2];
end
f2 = @(dxy) f2_x2y3(dxy,y,direction);
end


% example function 2nd derivative: z = x^2 + y^2
function H = f2_x2y3(dxy,y,direction)
if direction==1
    H = dxy.*[2*ones(size(y));6*y];
else
    H = dxy.*[2*ones(size(y)),6*y];
end
end


%%%%%%%%%%%%%%%%%%%%  Example function: z = x*y^2 %%%%%%%%%%%%%%%%%%%%

% example function: z = x*y^2
function [z,f1] = xy2(X,direction)
    if direction==1
        x = X(1,:);
        y = X(2,:);
    else
        x = X(:,1);
        y = X(:,2);
    end
    y2 = y.^2;
    z = x.*+y2;
    f1 = @() f1_xy2(x,y,y2,direction);
end

% example function 1st derivative: z = x*y^2
function [J,f2] = f1_xy2(x,y,y2,direction)
if direction==1
    J = [y2;2*x.*y];
else
    J = [y2,2*x.*y];
end
f2 = @(dxy) f2_xy2(dxy,x,y,direction);
end


% example function 2nd derivative: z = x*y^2
function H = f2_xy2(dxy,x,y,direction)
if direction==1
  dx = dxy(1,:);
  dy = dxy(2,:);
  H = [2*y.*dy;2*y.*dx+2*x.*dy];
else
  dx = dxy(:,1);
  dy = dxy(:,2);
  H = [2*y.*dy,2*y.*dx+2*x.*dy];
end
end





function test_this()

k = 5;
m = 2;

dr = 1;
fprintf('Testing x^2+y^2 in direction %i:\n\n',dr);
f = vectorized_function([],@(X)x2y3(X,dr),2,dr);
test_MV2DF(f,randn(k*m,1));

dr = 2;
fprintf('\n\n\n\nTesting x*y^2 in direction %i:\n\n',dr);
f = vectorized_function([],@(X)xy2(X,dr),2,dr);
test_MV2DF(f,randn(k*m,1));

end
