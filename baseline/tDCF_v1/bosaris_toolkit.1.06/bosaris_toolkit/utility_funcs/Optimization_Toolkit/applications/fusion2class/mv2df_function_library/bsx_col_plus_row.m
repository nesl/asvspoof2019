function fh = bsx_col_plus_row(m,n,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
% Algorithm: col = w(1:m)
%            row = w(m+1:end)
%            y = bsxfun(@plus,col(:),row(:)'), 
%



if nargin==0
    test_this();
    return;
end



    function y = map_this(w) 
        if isempty(m), m = length(w)-n; end
        col = w(1:m);
        row = w(m+1:end);
        y = bsxfun(@plus,col(:),row(:).');
    end


    function w = transmap_this(y,sz) 
    if isempty(m), m = sz-n; end
    y = reshape(y,m,[]); 
    w=zeros(sz,1); 
    w(1:m) = sum(y,2); 
    w(m+1:end) = sum(y,1).'; 
    end

map = @(w) map_this(w);
transmap = @(y,sz) transmap_this(y,sz);


fh = linTrans_adaptive([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()

m = 2;
n = 3;
w = randn(m+n,1);
f = bsx_col_plus_row(m,n);
test_MV2DF(f,w);


end
