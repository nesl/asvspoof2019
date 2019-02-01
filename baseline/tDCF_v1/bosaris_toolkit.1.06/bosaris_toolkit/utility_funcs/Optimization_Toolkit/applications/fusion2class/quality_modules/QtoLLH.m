function [LLH,w0] = QtoLLH(w,Q,n)
% 




if nargin==0
    test_this();
    return;
end


if ~exist('Q','var') || isempty(Q)
    LLH = sprintf(['QtoLLH:',repmat(' %g',1,length(w))],w);
    return;
end

[m,k] = size(Q);
wsz = m*n;
if nargout>1, w0 = zeros(wsz,1); end

LLH = linTrans(w,@(w)map_this(w),@(w)transmap_this(w));



    function y = map_this(w)
        w = reshape(w,n,m);
        y = w*Q;
    end

    function w = transmap_this(y)
        y = reshape(y,n,k);
        w = y*Q.';
    end




end

function test_this()

    Q = randn(2,10);
    [sys,w0] = QtoLLH([],Q,3);
    test_MV2DF(sys,w0);



end
