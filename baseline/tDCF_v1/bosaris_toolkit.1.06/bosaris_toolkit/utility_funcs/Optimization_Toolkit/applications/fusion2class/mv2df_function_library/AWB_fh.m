function fh = AWB_fh(A,B,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
% Algorithm: Y = A*reshape(w,..)*B


if nargin==0
    test_this();
    return;
end

[m,n] = size(A);
[r,s] =  size(B);

    function y = map_this(w) 
        w = reshape(w,n,r);
        y = A*w*B;
    end

    function w = transmap_this(y) 
        y = reshape(y,m,s);
        w = A.'*y*B.';
    end



map = @(y) map_this(y);
transmap = @(y) transmap_this(y);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()
A = randn(2,3);
B = randn(4,5);
f = AWB_fh(A,B);
test_MV2DF(f,randn(3*4,1));
end
