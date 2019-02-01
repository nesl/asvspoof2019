function fh = addtotranspose_fh(m,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.


if nargin==0
    test_this();
    return;
end



    function y = map_this(w) 
        w = reshape(w,m,m);
        y = w+w.';
    end

map = @(y) map_this(y);
transmap = @(y) map_this(y);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()
m=3;
f = addtotranspose_fh(3);
test_MV2DF(f,randn(m*m,1));
end
