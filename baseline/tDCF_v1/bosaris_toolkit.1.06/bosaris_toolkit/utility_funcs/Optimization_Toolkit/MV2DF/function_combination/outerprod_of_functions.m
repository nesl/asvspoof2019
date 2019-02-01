function [y,deriv] = outerprod_of_functions(w,f,g,m,n)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, 
%
%    g(w) = f(w)g(w)' 
%
% where f(w) and g(w) are column vectors of sizes m and n respectively.
%
% Here f,g are function handles to MV2DF's. 


if nargin==0
    test_this();
    return;
end

if ~exist('n','var'), n=[]; end


function A = extractA(w)
    if isempty(m), m = length(w)-n; end
    A = w(1:m);
    A = A(:);
end


function B = extractB(w)
    if isempty(m), m = length(w)-n; end
    B = w(1+m:end);
    B = B(:).';
end



if isempty(w) 

    s = stack(w,f,g);
    y = mm_special(s,@(w)extractA(w),@(w)extractB(w));
    return;
end


if isa(w,'function_handle')
    f = outerprod_of_functions([],f,g,m,n);
    y = compose_mv(f,w,[]);
    return;
end


f = outerprod_of_functions([],f,g,m,n);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end

end

function test_this()

m = 5;
n = 3;
w = randn(m+n,1);
f = subvec([],m+n,1,m);
g = subvec([],m+n,m+1,n);

h = outerprod_of_functions([],f,g,m,n);
test_MV2DF(h,w);
end
