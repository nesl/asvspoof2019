function [head,tail] = splitvec_fh(head_size,w)
% 
%
%  If head_size <0 then tail_size = - head_size
if nargin==0
    test_this();
    return;
end


tail_size = - head_size;
    function w = transmap_head(y,sz) 
    w=zeros(sz,1); 
    w(1:head_size)=y; 
    end
    function w = transmap_tail(y,sz) 
    w=zeros(sz,1); 
    w(head_size+1:end)=y; 
    end
    function w = transmap_head2(y,sz) 
    w=zeros(sz,1); 
    w(1:end-tail_size) = y; 
    end

    function w = transmap_tail2(y,sz) 
    w=zeros(sz,1); 
    w(1+end-tail_size:end) = y; 
    end



if head_size>0
    map_head = @(w) w(1:head_size);
    map_tail = @(w) w(head_size+1:end);
    head = linTrans_adaptive([],map_head,@(y,sz)transmap_head(y,sz));
    tail = linTrans_adaptive([],map_tail,@(y,sz)transmap_tail(y,sz));
elseif head_size<0
    map_head = @(w) w(1:end-tail_size);
    map_tail = @(w) w(1+end-tail_size:end);
    head = linTrans_adaptive([],map_head,@(y,sz)transmap_head2(y,sz));
    tail = linTrans_adaptive([],map_tail,@(y,sz)transmap_tail2(y,sz));
else
    error('head size cannot be 0')
end



if exist('w','var') && ~isempty(w)
    head = head(w);
    tail = tail(w);
end

end

function test_this()
[head,tail] = splitvec_fh(2);
fprintf('testing head:\n');
test_MV2DF(head,[1 2 3 4 5]);

fprintf('\n\n\ntesting tail:\n');
test_MV2DF(tail,[1 2 3 4 5]);

end
