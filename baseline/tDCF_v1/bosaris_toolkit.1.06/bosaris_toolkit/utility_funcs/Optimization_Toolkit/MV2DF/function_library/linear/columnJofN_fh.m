function fh = columnJofN_fh(j,n,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
%  w -> W = reshape(w,[],n) -> W(:,j)


if nargin==0
    test_this();
    return;
end


map = @(w) map_this(w,j,n);
transmap = @(y) transmap_this(y,j,n);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end


function w = transmap_this(y,j,n) 
W = zeros(length(y),n); 
W(:,j) = y;
w = W(:);
end

function col = map_this(w,j,n) 
W = reshape(w,[],n);
col = W(:,j);
end


function test_this()
m = 3; 
n = 4;
f = columnJofN_fh(2,4);
W = randn(m,n);
test_MV2DF(f,W(:));
end
