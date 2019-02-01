function [y,deriv] = logsumexp_special(w)
% This is a MV2DF. See MV2DF_API_DEFINITION.readme.
%
% If w = [x;r], where r is scalar and x vector, then
%    y = log(exp(x)+exp(r))

if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)logsumexp_special(w);
    return;
end

if isa(w,'function_handle')
    outer = logsumexp_special([]);
    y = compose_mv(outer,w,[]);
    return;
end


[r,x] = get_rx(w);
rmax = (r>x);
rnotmax = ~rmax;
y = zeros(size(x));
y(rmax) = log(exp(x(rmax)-r)+1)+r;
y(rnotmax) = log(exp(r-x(rnotmax))+1)+x(rnotmax);



if nargout>1
    deriv = @(Dy) deriv_this(Dy,r,x,y);
end


end

function [r,x] = get_rx(w)
w = w(:);
r = w(end);
x = w(1:end-1);
end


function [g,hess,linear] = deriv_this(dy,r,x,y)
gr = exp(r-y);
gx = exp(x-y);
g = [gx.*dy(:);gr.'*dy(:)];
linear = false;
hess = @(dw) hess_this(dw,dy,gr,gx);
end

function [h,Jv] = hess_this(dw,dy,gr,gx)
[dr,dx] = get_rx(dw);
p = gr.*gx.*dy;
h = [p.*(dx-dr);dr*sum(p)-dx.'*p];

if nargout>1
    Jv = gx.*dx+dr*gr;
end
end


function test_this()
f = logsumexp_special([]);

test_MV2DF(f,randn(5,1));

end
