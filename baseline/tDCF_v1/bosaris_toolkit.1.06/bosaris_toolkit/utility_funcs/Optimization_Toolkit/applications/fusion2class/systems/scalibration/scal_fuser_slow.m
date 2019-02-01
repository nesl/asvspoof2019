function [fusion,params] = scal_fuser_slow(w,scores)
% 
%  Does scal calibration
%
%  Inputs:
%    scores: M-by-N matrix of N scores for each of M input systems.
%    w: Optional: 
%         - when supplied, the output 'fusion' is the vector of fused scores.
%         - when w=[], the output 'fusion' is a function handle, to be used 
%                      for training the fuser.
%       w is a (K+1)-vector, with one weight per system, followed by the
%       offset.
%
%    fusion: if w is given, fusion is a vector of N fused scores.
%            if w is not given, fusion is a function handle, so that
%              fusion(w) = @(w) linear_fusion(scores,w).
%    w0: default values for w, to initialize training.
%
%  For training use: 
%     [fuser,params] = scal_fuser(train_scores);
%     w0 = params.get_w0();
%     w = train_binary_classifier(fuser,...,w0,...);
%
%  For test use:
%     fused_scores = scal_fuser(test_scores,w);
%




if nargin==0
    test_this();
    return;
end


if ~exist('scores','var') || isempty(scores)
    fusion = sprintf(['scal fuser:',repmat(' %g',1,length(w))],w);
    return;
end


[m,n] = size(scores);
wsz = size(scores,1)+1;
[wlin,wtail] = splitvec_fh(wsz);
[rs,wtail] = splitvec_fh(2,wtail);

map = @(rs) repmat(rs,n,1);
transmap =@(RS) sum(reshape(RS,2,[]),2);
RS = linTrans(rs,map,transmap);

X = fusion_mv2df(wlin,scores);
XRS = stack([],X,RS);
fusion = scalibration_fh(XRS);

if ~isempty(w)
    fusion = fusion(w);
    wtail = wtail(w);
end

params.get_w0 = @() [zeros(wsz,1);-5;-5];
params.tail = wtail;



end

function test_this()


N = 1000;
dim = 2;  % number of used systems

% ----------------synthesize training data -------------------
randn('state',0);
means = randn(dim,2)*8; %signal
[tar,non] = make_data(N,means);
tar = [tar,[min(non(1,:));min(non(2,:))]];
non = [non,[max(tar(1,:));max(tar(2,:))]];

% ------------- create system ------------------------------

[fuser,params] = scal_fuser([],[tar,non]);

% ------------- train it ------------------------------

ntar = size(tar,2);
nnon = size(non,2);
classf = [ones(1,ntar),-ones(1,nnon)];

prior = 0.1;
maxiters = 50;
quiet = false;
objfun = [];
w0 = params.get_w0();
[w,cxe] = train_binary_classifier(fuser,classf,w0,objfun,prior,[],0,maxiters,[],[],quiet);
fprintf('train Cxe = %g\n',cxe);

% ------------- test it ------------------------------

[tar,non] = make_data(N,means);
ntar = size(tar,2);
nnon = size(non,2);
classf = [ones(1,ntar),-ones(1,nnon)];


scores = [tar,non];
tail = [1;2;3];
wbig = [w;tail];
[fused_scores,params] = scal_fuser(wbig,scores);
check_tails = [tail,params.tail],
cxe = evaluate_objective(objfun,fused_scores,classf,prior);
fprintf('test Cxe = %g\n',cxe);

plot(fused_scores);

end

function [tar,non] = make_data(N,means)
[dim,K] = size(means);
X = 5*randn(dim,K*N); % noise
ii = 1:N;
for k=1:K
    X(:,ii) = bsxfun(@plus,means(:,k),X(:,ii));
    ii = ii+N;
end
N = K*N;
tar = X(:,1:N/2);
non = X(:,N/2+(1:N/2));

end
