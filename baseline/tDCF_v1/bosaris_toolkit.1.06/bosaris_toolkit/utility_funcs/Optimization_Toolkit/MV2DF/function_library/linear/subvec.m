function [y,deriv] = subvec(w,size,first,length)
% This is an MV2DF . See MV2DF_API_DEFINITION.readme.
% 
%  w --> w(first:first+length-1)
%


if nargin==0
    test_this();
    return;
end



last = first+length-1;

if isempty(w) 
    map = @(w) w(first:last);
    transmap = @(w) transmap_this(w,size,first,last);
    y = linTrans(w,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = subvec([],size,first,length);
    y = compose_mv(f,w,[]);
    return;
end

f = subvec([],size,first,length);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end




function g = transmap_this(w,size,first,last)
g = zeros(size,1);
g(first:last) = w;


function test_this()

f = subvec([],10,2,4);
test_MV2DF(f,randn(10,1));
