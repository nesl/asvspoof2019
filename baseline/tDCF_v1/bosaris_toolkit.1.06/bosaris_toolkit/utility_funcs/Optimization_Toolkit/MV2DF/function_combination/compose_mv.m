function [y,deriv] = compose_mv(outer,inner,x)
% COMPOSE_MV is an MV2DF (see MV2DF_API_DEFINITION.readme) which represents
% the combination of two functions. If 'outer' is an MV2DF for a function
% g() and 'inner' for a function f(), then this MV2DF represents g(f(x)).

%feature scopedaccelenablement off

if nargin==0
    test_this();
    return;
end


if isempty(x)
    y = @(w)compose_mv(outer,inner,w);
    return;
end

if isa(x,'function_handle')
    fh = compose_mv(outer,inner,[]);  % fh =@(x) outer(inner(x))
    y = compose_mv(fh,x,[]);          %  y =@(w) outer(inner(x(w)))
    return;
end

% if ~isa(outer,'function_handle')
%     outer = const_mv2df([],outer);
% end
% if ~isa(inner,'function_handle')
%     inner = const_mv2df([],inner);
% end



if nargout==1
    y = outer(inner(x));
    return;
end

[y1,deriv1] = inner(x);
[y,deriv2] = outer(y1);
deriv = @(g3) deriv_this(deriv1,deriv2,g3);



function [g,hess,linear] = deriv_this(deriv1,deriv2,g3)

if nargout==1
    g = deriv1(deriv2(g3));
    return;
end

[g2,hess2,lin2] = deriv2(g3);
[g,hess1,lin1] = deriv1(g2);

hess =@(d) hess_this(deriv1,hess1,hess2,lin1,lin2,d);

linear = lin1 && lin2;


function [h,Jv] = hess_this(deriv1,hess1,hess2,lin1,lin2,d)


if nargout==1
    if ~lin2
        [h1,Jv1] = hess1(d);
        h2 = hess2(Jv1);
        h2 = deriv1(h2);
    elseif ~lin1
        h1 = hess1(d);
    end
else
    [h1,Jv1] = hess1(d);
    [h2,Jv] = hess2(Jv1);
    if ~lin2
        h2 = deriv1(h2);
    end
end

if lin1 && lin2
    h=[];
elseif (~lin1) && (~lin2)
    h = h1+h2;
elseif lin1
    h = h2;
else % if lin2
    h = h1;
end

function test_this()

fprintf('-------------- Test 1 ------------------------\n');
fprintf('Composition g(f(w)): f() is non-linear and g() is non-linear:\n');
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];

f = @(w) gemm(w,4,5,4);
g1 = gemm(f,2,4,2);

test_MV2DF(g1,w);
fprintf('--------------------------------------\n\n');


fprintf('-------------- Test 2 ------------------------\n');
fprintf('Composition g(f(w)): f() is linear and g() is non-linear:\n');
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];


T = randn(40);
f = @(w) linTrans(w,@(x)T*x,@(y)T.'*y);
g2 = gemm(f,4,5,4);

test_MV2DF(g2,w);
fprintf('--------------------------------------\n\n');


fprintf('-------------- Test 3 ------------------------\n');
fprintf('Composition g(f(w)): f() is non-linear and g() is linear:\n');
A = randn(4,5);
B = randn(5,4);

w = [A(:);B(:)];
f = @(w) gemm(w,4,5,4);

T = randn(16);
g3 = linTrans(f,@(x)T*x,@(y)T.'*y);

test_MV2DF(g3,w);
fprintf('--------------------------------------\n\n');




fprintf('-------------- Test 4 ------------------------\n');
fprintf('Composition g(f(w)): f() is linear and g() is linear:\n');
w = randn(10,1);
T1 = randn(11,10);
f = @(w) linTrans(w,@(x)T1*x,@(y)T1.'*y);

T2 = randn(5,11);
g4 = linTrans(f,@(x)T2*x,@(y)T2.'*y);


test_MV2DF(g4,w);
fprintf('--------------------------------------\n\n');
