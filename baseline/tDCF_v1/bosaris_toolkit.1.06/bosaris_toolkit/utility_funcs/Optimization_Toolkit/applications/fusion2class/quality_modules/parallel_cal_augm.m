function [calscores,params] = parallel_cal_augm(w,scores)
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
scores = [scores;zeros(1,n)];
wsz = 2*m;

[whead,wtail] = splitvec_fh(wsz,w);
params.get_w0 = @(wfuse) init_w0(wfuse);
params.tail = wtail;

waugm = augmentmatrix_fh(m,0,whead);
calscores = linTrans(waugm,@(w)map_this(w),@(w)transmap_this(w));


    function w0 = init_w0(wfuse)
        scal = wfuse(1:end-1);
        offs = wfuse(end);
        W = [scal*(m+1);((m+1)/m)*offs*ones(m,1)];
        w0 = W(:);
    end

    function y = map_this(w)
        w = reshape(w,m+1,2);
        y = bsxfun(@times,scores,w(:,1));
        y = bsxfun(@plus,y,w(:,2));
    end

    function w = transmap_this(y)
        y = reshape(y,m+1,n);
        w = [sum(y.*scores,2),sum(y,2)];
    end




end

function test_this()

    scores = randn(4,10);
    [sys,params] = parallel_cal_augm([],scores);
    w0 = params.get_w0();
    test_MV2DF(sys,w0);



end
