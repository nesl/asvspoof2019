function fh = subvec_fh(first,len,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.


if nargin==0
    test_this();
    return;
end


map = @(w) w(first:first+len-1);

    function w = transmap_this(y,sz) 
    w=zeros(sz,1); 
    w(first:first+len-1)=y; 
    end
transmap = @(y,sz) transmap_this(y,sz);


fh = linTrans_adaptive([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()
first = 2;
len = 3;
f = subvec_fh(first,len);
test_MV2DF(f,randn(5,1));
end
