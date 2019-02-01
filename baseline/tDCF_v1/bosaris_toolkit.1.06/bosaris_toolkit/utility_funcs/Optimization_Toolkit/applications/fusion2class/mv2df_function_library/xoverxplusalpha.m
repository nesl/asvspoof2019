function [y,deriv] = xoverxplusalpha(w,x)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   alpha --> x./(x+alpha) 
%

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    y = @(w)xoverxplusalpha(w,x);
    return;
end


if isa(w,'function_handle')
    f = xoverxplusalpha([],x);
    y = compose_mv(f,w,[]);
    return;
end

x = x(:);
assert(numel(w)==1);
y = x./(x+w);

deriv = @(Dy) deriv_this(Dy,x,w);

end

function [g,hess,linear] = deriv_this(Dy,x,w)
g0 = -x./(x+w).^2;
g = Dy.'*g0;
linear = false;
hess = @(Dw) hess_this(Dw,Dy,x,w,g0);
end

function [h,Jv] = hess_this(Dw,Dy,x,w,g0)
  h = 2*Dw * Dy.'*(x./(x+w).^3);
  if nargin>1
      Jv = Dw*g0;
  end
end



function test_this()

x = randn(1,100);
w = randn(1);
f = xoverxplusalpha([],x);
test_MV2DF(f,w);

end
