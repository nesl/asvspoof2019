function [y,deriv] = fusion_mv2df(w,scores)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% The function is a 'score fusion' computed thus:
%   y.' = w(1:end-1).'*scores + w(end)
%
%         Here w is the vector of fusion weights, one weight per system and 
%         an offset.
%
% Parameters:
%     scores: is an M-by-T matrix of scores from M systems, for each of T
%             trials.
%
% Note (even though the fusion is affine from input scores to output
% scores) this MV2DF is a linear transform from w to y.


if nargin==0
    test_this();
    return;
end

if isempty(w) 
    map = @(w) map_this(w,scores);
    transmap = @(w) transmap_this(w,scores);
    y = linTrans(w,map,transmap);
    return;
end

if isa(w,'function_handle')
    f = fusion_mv2df([],scores);
    y = compose_mv(f,w,[]);
    return;
end


f = fusion_mv2df([],scores);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end




function y = map_this(w,scores)
y = w(1:end-1).'*scores + w(end);
y = y(:);

function y = transmap_this(x,scores)
y = [scores*x;sum(x)];


function test_this()
K = 5;
N = 10;
w = randn(N+1,1);
scores = randn(N,K);

f = fusion_mv2df([],scores);
test_MV2DF(f,w);
