function [y,deriv] = shift_function(w,shift,f)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, 
%
%    g(w) = shift(w)+f(w), 
%
% where shift is scalar-valued and f is matrix-valued.
%
%
% Here shift and f are function handles to MV2DF's. 


if nargin==0
    test_this();
    return;
end

if isempty(w) 

    s = stack(w,shift,f);
    map = @(s) s(2:end)+s(1); 
    transmap = @(y) [sum(y);y];
    y = linTrans(s,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = shift_function([],shift,f);
    y = compose_mv(f,w,[]);
    return;
end


f = shift_function([],shift,f);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function test_this()

m = 5;
n = 10;
data = randn(m,n);
shift = 3;
w = [data(:);shift];

g = subvec([],m*n+1,1,m*n);
shift = subvec([],m*n+1,m*n+1,1);


f = shift_function([],shift,g);
test_MV2DF(f,w);


