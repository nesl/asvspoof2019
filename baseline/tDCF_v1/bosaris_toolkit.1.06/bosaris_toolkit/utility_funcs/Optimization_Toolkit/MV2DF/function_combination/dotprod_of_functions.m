function [y,deriv] = dotprod_of_functions(w,f,g)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, 
%
%    g(w) = f(w)'g(w) 
%
% where f(w) and g(w) are column vectors of the same size.
%
% Here f,g are function handles to MV2DF's. 


if nargin==0
    test_this();
    return;
end


function A = extractA(w)
    A = w(1:length(w)/2);
    A = A(:).';
end


function B = extractB(w)
    B = w(1+length(w)/2:end);
    B = B(:)    ;
end



if isempty(w) 

    s = stack(w,f,g);
    y = mm_special(s,@(w)extractA(w),@(w)extractB(w));
    return;
end


if isa(w,'function_handle')
    f = dotprod_of_functions([],f,g);
    y = compose_mv(f,w,[]);
    return;
end


f = dotprod_of_functions([],f,g);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end

end

function test_this()

m = 5;
w = randn(2*m,1);
f = subvec([],2*m,1,m);
g = subvec([],2*m,m+1,m);

h = dotprod_of_functions([],f,g);
test_MV2DF(h,w);
end
