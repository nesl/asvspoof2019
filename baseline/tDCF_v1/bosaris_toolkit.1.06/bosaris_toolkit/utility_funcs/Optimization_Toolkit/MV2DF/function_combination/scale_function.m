function [y,deriv] = scale_function(w,scale,f)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, 
%
%    g(w) = scale(w)*f(w), 
%
% where scale is scalar-valued and f is matrix-valued.
%
%
% Here scale and f are function handles to MV2DF's. 


if nargin==0
    test_this();
    return;
end

if isempty(w) 

    s = stack(w,f,scale);
    y = mm_special(s,@(w)reshape(w(1:end-1),[],1),@(w)w(end));
    return;
end


if isa(w,'function_handle')
    f = scale_function([],scale,f);
    y = compose_mv(f,w,[]);
    return;
end


f = scale_function([],scale,f);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function test_this()

m = 5;
n = 10;
data = randn(m,n);
scal = 3;
w = [data(:);scal];

g = subvec([],m*n+1,1,m*n);
scal = subvec([],m*n+1,m*n+1,1);


f = scale_function([],scal,g);
test_MV2DF(f,w);
