function fh = augmentmatrix_fh(m,value,w)
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
% Algorithm: y = [reshape(w,m,n);ones(1,n)](:)


if nargin==0
    test_this();
    return;
end



    function y = map_this(w) 
        n = length(w)/m;
        y = [reshape(w,m,n);value*ones(1,n)];
    end

    function y = linmap_this(w) 
        n = length(w)/m;
        y = [reshape(w,m,n);zeros(1,n)];
    end

    function w = transmap_this(y) 
        y = reshape(y,m+1,[]);
        w = y(1:m,:);
    end

map = @(w) map_this(w);
linmap = @(w) linmap_this(w);
transmap = @(y) transmap_this(y);


fh = affineTrans([],map,linmap,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()

m = 3;
f = augmentmatrix_fh(m,1);
test_MV2DF(f,randn(m*4,1));

end
