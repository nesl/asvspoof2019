function [y,deriv] = linTrans_adaptive(w,map,transmap)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Applies linear transform y = map(w). It needs the transpose of map, 
% transmap for computing the gradient. map and transmap are function
% handles.

if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)linTrans_adaptive(w,map,transmap);
    return;
end

if isa(w,'function_handle')
    outer = linTrans_adaptive([],map,transmap);
    y = compose_mv(outer,w,[]);
    return;
end

y = map(w);
y = y(:);

deriv = @(g2) deriv_this(g2,map,transmap,numel(w));
end

function [g,hess,linear] = deriv_this(g2,map,transmap,wlen)
g = transmap(g2,wlen);
g = g(:);
%linear = false;  % use this to test linearity of map, if in doubt
linear = true;
hess = @(d) hess_this(map,d);
end

function [h,Jd] = hess_this(map,d)
h = [];
if nargout>1 
    Jd = map(d);
    Jd = Jd(:);
end

end

function test_this()
first = 2;
len = 3;
map = @(w) w(first:first+len-1);
function w = transmap_test(y,sz) 
    w=zeros(sz,1); 
    w(first:first+len-1)=y; 
end
transmap = @(y,sz) transmap_test(y,sz);
f = linTrans_adaptive([],map,transmap);
test_MV2DF(f,randn(5,1));
end
