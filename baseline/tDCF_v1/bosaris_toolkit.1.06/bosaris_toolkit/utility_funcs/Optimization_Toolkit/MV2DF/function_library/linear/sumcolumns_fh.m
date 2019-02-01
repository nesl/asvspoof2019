function fh = sumcolumns_fh(m,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
%  w -> W = reshape(w,m,[]) -> sum(W,1)'


if nargin==0
    test_this();
    return;
end


map = @(w) map_this(w,m);
transmap = @(y) transmap_this(y,m);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end


function w = transmap_this(y,m) 
  w = repmat(y(:).',m,1);
end

function s = map_this(w,m) 
W = reshape(w,m,[]);
s = sum(W,1);
end


function test_this()
m = 3; 
n = 4;
f = sumcolumns_fh(m);
W = randn(m,n);
test_MV2DF(f,W(:));
end
