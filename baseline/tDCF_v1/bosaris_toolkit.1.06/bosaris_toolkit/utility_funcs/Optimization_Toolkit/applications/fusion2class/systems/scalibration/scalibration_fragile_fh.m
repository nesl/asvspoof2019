function f = scalibration_fragile_fh(direction,w)
%
% Don't use this function, it is just for reference. It will break for
% large argument values.
%
% This is a factory for a function handle to an MV2DF, which represents
% the vectorization of the logsumexp function. The whole mapping works like
% this, in MATLAB-style psuedocode:
%
%   F: R^(m*n) --> R^n, where y = F(x) is computed thus:
%
%   n = length(x)/m
%   If direction=1, X = reshape(x,m,n), or 
%   if direction=1, X = reshape(x,n,m). 
%   y = log(sum(exp(X),direction))
%
% Inputs: 
%   m: the number of inputs to each individual logsumexp calculation.
%   direction: 1 sums down columns, or 2 sums accross rows.
%   w: optional, if ssupplied 
%
% Outputs:
%   f: a function handle to the MV2DF described above.
%
% see: MV2DF_API_DEFINITION.readme


if nargin==0
    test_this();
    return;
end


f = vectorized_function([],@(X)F0(X,direction),3,direction);

if exist('w','var') && ~isempty(w)
    f = f(w);
end

end

function [y,f1] = F0(X,dr)
if dr==1
    x = X(1,:);
    p = X(2,:);
    q = X(3,:);
else
    x = X(:,1);
    p = X(:,2);
    q = X(:,3);
end
expx = exp(x);
num = (expx-1).*p+1;
den = (expx-1).*q+1;
y = log(num)-log(den);
f1 = @() F1(expx,p,q,num,den,dr);
end

function [J,f2,linear] = F1(expx,p,q,num,den,dr)
linear = false;
if dr==1
    J = [expx.*(p-q)./(num.*den);(expx-1)./num;-(expx-1)./den];
else
    J = [expx.*(p-q)./(num.*den),(expx-1)./num,-(expx-1)./den];
end
f2 = @(dX) F2(dX,expx,p,q,num,den,dr);
end

function H = F2(dX,expx,p,q,num,den,dr)
d2dx2 = -expx.*(p-q).*(p+q+p.*q.*(expx.^2-1)-1)./(num.^2.*den.^2);
d2dxdp = expx./num.^2;
d2dxdq = -expx./den.^2;
d2dp2 = -(expx-1).^2./num.^2;
d2dq2 = (expx-1).^2./den.^2;
if dr==1
    dx = dX(1,:);
    dp = dX(2,:);
    dq = dX(3,:);
    H = [
         dx.*d2dx2+dp.*d2dxdp+dq.*d2dxdq; ...
         dx.*d2dxdp+dp.*d2dp2; ...
         dx.*d2dxdq+dq.*d2dq2...
        ];
else
    dx = dX(:,1);
    dp = dX(:,2);
    dq = dX(:,3);
    H = [
         dx.*d2dx2+dp.*d2dxdp+dq.*d2dxdq, ...
         dx.*d2dxdp+dp.*d2dp2, ...
         dx.*d2dxdq+dq.*d2dq2...
        ];
end
end



function test_this()
n = 10;
x = randn(1,n);
p = rand(1,n);
q = rand(1,n);
X = [x;p;q];

fprintf('testing dir==1:\n');
f = scalibration_fragile_fh(1);
test_MV2DF(f,X(:));

fprintf('\n\n\ntesting dir==2:\n');
f = scalibration_fragile_fh(2);
X = X';
test_MV2DF(f,X(:));

end
