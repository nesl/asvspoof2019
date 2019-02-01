function fh = tril_to_symm_fh(m,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
% Algorithm: w is vector of sizem*(m+1)/2
%            w -> m-by-m lower triangular matrix Y
%            Y -> Y + Y' 

if nargin==0
    test_this();
    return;
end


indx = tril(true(m));

    function y = map_this(w) 
        y = zeros(m);
        y(indx(:)) = w;
        y = y + y.';
    end

    function w = transmap_this(y) 
        y = reshape(y,m,m);
        y = y + y.';
        w = y(indx(:));
    end

map = @(w) map_this(w);
transmap = @(y) transmap_this(y);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()
m=3;
n = m*(m+1)/2;
f = tril_to_symm_fh(m);
test_MV2DF(f,randn(n,1));
end
