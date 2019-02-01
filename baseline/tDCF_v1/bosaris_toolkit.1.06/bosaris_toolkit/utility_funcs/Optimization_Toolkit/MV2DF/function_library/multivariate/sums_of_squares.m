function [y,deriv] = sums_of_squares(w,m)
% This is a MV2DF. See MV2DF_API_DEFINITION.readme.
% Does:
% (i) Reshapes w to m-by-n. 
% (ii) Computes sum of squares of each of n columns. 
% (iii) Transposes to output n-vector.


if nargin==0
    test_this();
    return;
end


if isempty(w)
    y = @(w)sums_of_squares(w,m);
    return;
end

if isa(w,'function_handle')
    outer = sums_of_squares([],m);
    y = compose_mv(outer,w,[]);
    return;
end



M = reshape(w,m,[]);
y = sum(M.^2,1);
y = y(:);

deriv = @(g2) deriv_this(g2,M);


function [g,hess,linear] = deriv_this(g2,M)

g = 2*bsxfun(@times,M,g2.');
g = g(:);
linear = false;
hess = @(d) hess_this(d,g2,M);


function [h,Jv] = hess_this(d,g2,M)
h = deriv_this(g2,reshape(d,size(M)));
if nargout>1
    Jv = 2*sum(reshape(d,size(M)).*M,1);
    Jv = Jv(:);
end


function test_this()
f = sums_of_squares([],10);
test_MV2DF(f,randn(10*4,1));
