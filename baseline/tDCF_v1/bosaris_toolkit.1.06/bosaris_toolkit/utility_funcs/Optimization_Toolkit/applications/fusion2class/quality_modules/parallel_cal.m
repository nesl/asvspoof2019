function [calscores,w0] = parallel_cal(w,scores,wfuse)
% 




if nargin==0
    test_this();
    return;
end


if ~exist('scores','var') || isempty(scores)
    calscores = sprintf(['parallel calibration:',repmat(' %g',1,length(w))],w);
    return;
end

[m,n] = size(scores);


if nargout>1, w0 = init_w0(wfuse); end

calscores = linTrans(w,@(w)map_this(w),@(w)transmap_this(w));


    function w0 = init_w0(wfuse)
        assert(length(wfuse)-1==m);
        scal = wfuse(1:end-1);
        offs = wfuse(end);
        W = [scal*(m+1);((m+1)/m)*offs*ones(m,1)];
        w0 = W(:);
    end


    function y = map_this(w)        
        w = reshape(w,m,2);
        y = bsxfun(@times,scores,w(:,1));
        y = bsxfun(@plus,y,w(:,2));
    end

    function w = transmap_this(y)
        y = reshape(y,m,n);
        w = [sum(y.*scores,2),sum(y,2)];
    end




end

function test_this()

    scores = randn(4,10);
    [sys,w0] = parallel_cal([],scores,(1:5)');
    test_MV2DF(sys,w0);

end
