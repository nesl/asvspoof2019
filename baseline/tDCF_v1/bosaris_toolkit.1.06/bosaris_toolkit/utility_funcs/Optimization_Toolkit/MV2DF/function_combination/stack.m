function [y,deriv] = stack(w,f,g,eqlen)
% STACK is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, s(w), obtained by stacking the outputs of 
% f() and g() thus:
%  s(w) = [f(w);g(w)] 


if nargin==0
    test_this();
    return;
end

if ~exist('eqlen','var')
    eqlen = false;
end

if isempty(w)
    y = @(w)stack(w,f,g,eqlen);
    return;
end

if isa(w,'function_handle')
    outer = stack([],f,g,eqlen);
    y = compose_mv(outer,w,[]);
    return;
end

% if ~isa(f,'function_handle')
%     f = const_mv2df([],f);
% end
% if ~isa(g,'function_handle')
%     g = const_mv2df([],g);
% end

w = w(:);

if nargout==1
    y1 = f(w);
    y2 = g(w);
    n1 = length(y1);
    n2 = length(y2);
    if eqlen, assert(n1==n2,'length(f(w))=%i must equal length(g(w))=%i.',n1,n2); end
    y = [y1;y2];
    return;
end

[y1,deriv1] = f(w);
[y2,deriv2] = g(w);
y = [y1;y2];
n1 = length(y1);
n2 = length(y2);
if eqlen, assert(n1==n2,'length(f(w))=%i must equal length(g(w))=%i.',n1,n2); end
deriv = @(g2) deriv_this(g2,deriv1,deriv2,n1);


function [g,hess,linear] = deriv_this(y,deriv1,deriv2,n1)

if nargout==1
    g1 = deriv1(y(1:n1));
    g2 = deriv2(y(n1+1:end));
    g = g1 + g2;
    return;
end

[g1,hess1,lin1] = deriv1(y(1:n1));
[g2,hess2,lin2] = deriv2(y(n1+1:end));

g = g1+g2;
linear = lin1 && lin2;
hess = @(d) hess_this(d,hess1,hess2,lin1,lin2);


function [h,Jv] = hess_this(d,hess1,hess2,lin1,lin2)

if nargout>1
    [h1,Jv1] = hess1(d);
    [h2,Jv2] = hess2(d);
    Jv = [Jv1;Jv2];
else
    [h1] = hess1(d);
    [h2] = hess2(d);
end

if lin1 && lin2
    h = [];
elseif ~lin1 && ~lin2
   h = h1 + h2;
elseif lin2
   h = h1;
else
   h = h2;
end


function test_this()
fprintf('-------------- Test 1 ------------------------\n');
fprintf('Stack [f(w);g(w)]: f() is non-linear and g() is non-linear:\n');


A = randn(4,5);
B = randn(5,4);


w = [];
f = gemm(w,4,5,4);
g = gemm(subvec(w,40,1,20),2,5,2);

s = stack(w,f,g);


w = [A(:);B(:)];
test_MV2DF(s,w);

fprintf('--------------------------------------\n\n');


fprintf('-------------- Test 2 ------------------------\n');
fprintf('Stack [f(w);g(w)]: f() is linear and g() is non-linear:\n');
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];


T = randn(40);
f = @(w) linTrans(w,@(x)T*x,@(y)T.'*y);
g = @(w) gemm(w,4,5,4);

s = @(w) stack(w,f,g);


test_MV2DF(s,w);
fprintf('--------------------------------------\n\n');


fprintf('-------------- Test 3 ------------------------\n');
fprintf('Stack [f(w);g(w)]: f() is non-linear and g() is linear:\n');
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];


T = randn(40);
f = @(w) linTrans(w,@(x)T*x,@(y)T.'*y);
g = @(w) gemm(w,4,5,4);

s = @(w) stack(w,g,f);


test_MV2DF(s,w);
fprintf('--------------------------------------\n\n');




fprintf('-------------- Test 4 ------------------------\n');
fprintf('Stack [f(w);g(w)]: f() is linear and g() is linear:\n');
w = randn(10,1);
T1 = randn(11,10);
f = @(w) linTrans(w,@(x)T1*x,@(y)T1.'*y);

T2 = randn(12,10);
g = @(w) linTrans(w,@(x)T2*x,@(y)T2.'*y);
s = @(w) stack(w,g,f);


test_MV2DF(s,w);
fprintf('--------------------------------------\n\n');
