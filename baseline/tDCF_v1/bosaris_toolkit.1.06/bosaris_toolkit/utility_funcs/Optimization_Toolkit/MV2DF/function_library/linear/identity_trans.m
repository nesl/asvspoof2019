function [y,deriv] = identity_trans(w)
% This is an MV2DF . See MV2DF_API_DEFINITION.readme.
% 
%  w --> w
%


if nargin==0
    test_this();
    return;
end


if isempty(w) 
    map = @(w) w;
    y = linTrans(w,map,map);
    return;
end

if isa(w,'function_handle')
    f = identity_trans([]);
    y = compose_mv(f,w,[]);
    return;
end

f = identity_trans([]);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end

function test_this()

f = identity_trans([]);
test_MV2DF(f,randn(5,1));
