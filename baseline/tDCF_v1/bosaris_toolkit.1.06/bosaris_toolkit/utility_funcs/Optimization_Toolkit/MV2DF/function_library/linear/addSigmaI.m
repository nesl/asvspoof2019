function [y,deriv] = addSigmaI(w)
% This is an MV2DF . See MV2DF_API_DEFINITION.readme.
% 
%  
%


if nargin==0
    test_this();
    return;
end


if isempty(w) 
    map = @(w) map_this(w);
    transmap = @(w) transmap_this(w);
    y = linTrans(w,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = addSigmaI([]);
    y = compose_mv(f,w,[]);
    return;
end

f = addSigmaI([]);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function y = map_this(w)
w = w(:);
y = w(1:end-1);
sigma = w(end);
dim  = sqrt(length(y));
ii = 1:dim+1:dim*dim;
y(ii) = w(ii)+sigma;


function w = transmap_this(y)
dim = sqrt(length(y));
ii = 1:dim+1:dim*dim;
w = [y;sum(y(ii))];

function test_this()
dim = 5;
f = addSigmaI([]);
test_MV2DF(f,randn(dim*dim+1,1));
