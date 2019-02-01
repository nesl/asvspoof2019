function [y,deriv] = scaleColumns(w,scales)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   w --> bsxfun(@times,reshape(w,[],n),scales(:)')
%
%   where n = length(scales);
%
% Note: this is a symmetric linear transform.

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    map = @(w)map_this(w,scales);
    y = linTrans(w,map,map);
    return;
end


if isa(w,'function_handle')
    f = scaleColumns([],scales);
    y = compose_mv(f,w,[]);
    return;
end
    


f = scaleColumns([],scales);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end




function w = map_this(w,scales)
n = length(scales);
w = reshape(w,[],n);
w = bsxfun(@times,w,scales(:)');



function test_this()
K = 5;
N = 10;
M = randn(K,N);
scales = randn(1,N);

f = scaleColumns([],scales);
test_MV2DF(f,M(:));
