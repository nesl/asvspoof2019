function [y,deriv] = interleave(w,functions)
% interleave is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, s(w), obtained by interleaving the outputs of 
% f() and g() thus:
%
%    S(w) = [f(w)';g(w)'];
%    s(w) = S(:); 


if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)interleave(w,functions);
    return;
end

if isa(w,'function_handle')
    outer = interleave([],functions);
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

m = length(functions);
k = length(w);

if nargout==1
    y1 = functions{1}(w);
    n = length(y1);
    y = zeros(m,n);
    y(1,:) = y1;
    for i=2:m
        y(i,:) = functions{i}(w);
    end
    y = y(:);
    return;
end

deriv = cell(1,m);
[y1,deriv{1}] = functions{1}(w);
n = length(y1);
y = zeros(m,n);
y(1,:) = y1;
for i=2:m
    [y(i,:),deriv{i}] = functions{i}(w);
end
y = y(:);

deriv = @(g2) deriv_this(g2,deriv,m,n,k);


function [g,hess,linear] = deriv_this(y,deriv,m,n,k)

y = reshape(y,m,n);
if nargout==1
    g = deriv{1}(y(1,:).');
    for i=2:m
        g = g+ deriv{i}(y(i,:).');
    end
    return;
end

hess = cell(1,m);
lin = false(1,m);
[g,hess{1},lin(1)] = deriv{1}(y(1,:).');
linear = lin(1);
for i=2:m
    [gi,hess{i},lin(i)] = deriv{i}(y(i,:).');
    g = g + gi;
    linear = linear && lin(i);
end
hess = @(d) hess_this(d,hess,lin,m,n,k);


function [h,Jv] = hess_this(d,hess,lin,m,n,k)

if all(lin)
    h = [];
else
    h = zeros(k,1);
end

if nargout>1
    Jv = zeros(m,n);
    for i=1:m
        [hi,Jv(i,:)] = hess{i}(d);
        if ~lin(i)
            h = h + hi;
        end
    end
    Jv = Jv(:);
else
    for i=1:m
        hi = hess{i}(d);
        if ~lin(i)
            h = h + hi;
        end
    end
end

function test_this()

w = [];
f = exp_mv2df(w);
g = square_mv2df(w);
h = identity_trans(w);

s = interleave(w,{f,g,h});


w = randn(5,1);
test_MV2DF(s,w);
