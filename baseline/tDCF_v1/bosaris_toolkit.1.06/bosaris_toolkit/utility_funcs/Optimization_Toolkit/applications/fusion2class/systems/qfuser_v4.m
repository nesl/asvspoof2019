function [fusion,w0] = qfuser_v4(w,scores,wfuse)
% qindx: index set for rows of scores.scores which are per-trial quality
%        measures.
%
% sindx: index set for rows of scores.scores which are normal discriminative 
%        scores.

if nargin==0
    test_this();
    return;
end


sindx = scores.sindx;
qindx = scores.qindx;
m =length(sindx);


% Create building blocks
[Cal,w1] = parallel_cal([],scores.scores(sindx,:),wfuse);
[whead,wtail] = splitvec_fh(length(w1));
Cal = Cal(whead);


[LLH1,w2] = QQtoLLH([],scores.modelQ,scores.segQ,m);
[whead,wtail] = splitvec_fh(length(w2),wtail);
LLH1 = LLH1(whead);
W2 = reshape(w2,[],m);
W2(:) = 0;
W2(end,:) = 0.5/(m+1);
w2 = W2(:);


[LLH2,w3] = QtoLLH([],scores.scores(qindx,:),m);
LLH2 = LLH2(wtail);


LLH =  sum_of_functions([],[1,1],LLH1,LLH2);
%LLH = LLH1;

P = LLH;
%P = exp_mv2df(logsoftmax_trunc_mv2df(LLH,m));


w0 = [w1;w2;w3];



% Assemble building blocks

%  modulate linear fusion with quality
fusion = sumcolumns_fh(m,dottimes_of_functions(w,P,Cal));



end


function test_this()

m = 5;
k = 2;
n1 = 4;
n2 = 5;

scores.sindx = [1,2,3];
scores.qindx = [4,5];

scores.scores = randn(m,n1*n2);
scores.modelQ = randn(k,n1);
scores.segQ = randn(k,n2);

wfuse = [1,2,3,4]';

[fusion,w0] = qfuser_v4([],scores,wfuse);

%test_MV2DF(fusion,w0);

[fusion(w0),linear_fuser(wfuse,scores.scores(scores.sindx,:))]

%fusion(w0)


end
