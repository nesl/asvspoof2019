function [w,mce,divergence,w_pen,c_pen,optimizerState,converged] = train_system(classf,system,penalizer,W0,lambda,confusion,maxiters,maxCG,prior,optimizerState)
% 
%   Supervised training of a regularized K-class linear logistic
%   regression. Allows regularization via weight penalties and via
%   label confusion probabilities.
%
%
% Inputs:
%   classf: 1-by-N row of class labels, in the range 1..K
%
%   system: MV2DF function handle that maps parameters to score matrix.
%           Note: The system input data is already wrapped in this handle.
%   
%   penalizer: MV2DF function handle that maps parameters to a positive regularization penalty.
%
%
%   W0: initial parameters. This is NOT optional. 
%
%
%   confusion: a scalar or a matrix of label confusion probabilities
%           -- if this is a K-by-K matrix, then 
%              entry_ij denotes P(label_j | class i)
%
%           -- if scalar: confusion = q, then 
%              P(label_i | class_i) = 1-q, and
%              P(label_j | class_i) = q/(K-1)
%           
%  maxiters: the maximum number of Newton Trust Region optimization
%            iterations to perform. Note, the user can make maxiters
%            small, examine the solution and then continue training:
%            -- see W0 and optimizerState.
%
%
%  prior: a prior probability distribution over the K classes to
%         modify the optimization operating point.
%         optional: 
%           omit or use []
%           default is prior = ones(1,K)/K
%
%  optimizerState: In this implementation, it is the trust region radius.
%                  optional: 
%                    omit or use []
%                    If not supplied when resuming iteration,
%                    this may cost some extra iterations. 
%                  Resume further iteration thus:
%   [W1,...,optimizerState] = train_..._logregr(...);
%   ... examine solution W1  ...
%   [W2,...,optimizerState] = train_..._logregr(...,W1,...,optimizerState);
%                
%
%  
%
%
%  Outputs:
%    W: the solution. 
%    mce: normalized multiclass cross-entropy of the solution. 
%         The range is 0 (good) to 1(useless).
%
%    optimizerState: see above, can be used to resume iteration.
%  





if nargin==0
    test_this();
    return;
end



classf = classf(:)';
K = max(classf);
N = length(classf);



if ~exist('maxCG','var') || isempty(maxCG)
    maxCG = 100;
end


if ~exist('optimizerState','var')
    optimizerState=[];
end

if ~exist('prior','var') || isempty(prior)
    prior = ones(K,1)/K;
else
    prior = prior(:);
end


weights = zeros(1,N);
for k = 1:K
    fk = find(classf==k);
    count = length(fk);
    weights(fk) = prior(k)/(count*log(2));
end


if ~exist('confusion','var') || isempty(confusion)
    confusion = 0;
end


if isscalar(confusion)
    q = confusion;
    confusion = (1-q)*eye(K) + (q/(K-1))*(ones(K)-eye(K));
end


post = bsxfun(@times,confusion,prior(:));
post = bsxfun(@times,post,1./sum(post,1));


logpost = post;
nz = logpost>0;
logpost(nz) = log(post(nz));
confusion_entropy = -mean(sum(post.*logpost,1),2);
prior_entropy = -log(prior)'*prior;
c_pen = confusion_entropy/prior_entropy;
fprintf('normalized confusion entropy = %g\n',c_pen);


T = zeros(K,N);
for i=1:N
    T(:,i) = post(:,classf(i));
end


w=[];    

obj1 = mce_obj(system,T,weights,log(prior));
obj2 = penalizer(w);
obj = sum_of_functions(w,[1,lambda],obj1,obj2);

w0 = W0(:);


[w,y,optimizerState,converged] = trustregion_newton_cg(obj,w0,maxiters,maxCG,optimizerState,[],1);

w_pen = lambda*obj2(w)/prior_entropy;


mce = y/prior_entropy-w_pen;
divergence = mce-c_pen;
fprintf('mce = %g, divergence = %g, conf entr = %g, weight pen = %g\n',mce,divergence,c_pen,w_pen);




function y = score_map(W,X)
[dim,N] = size(X);
W = reshape(W,[],dim+1);
offs = W(:,end);
W(:,end)=[];
y = bsxfun(@plus,W*X,offs);
y = y(:);

function W = score_transmap(y,X)
[dim,N] = size(X);
y = reshape(y,[],N).';
W = [X*y;sum(y)]; 
W = W.';
W = W(:);

function test_this()


K = 3;
N = 100;
dim = 2;


% ----------------syntesize data -------------------
randn('state',0);
means = randn(dim,K)*10; %signal
X = randn(dim,K*N); % noise
classf = zeros(1,K*N);
ii = 1:N;
for k=1:K
    X(:,ii) = bsxfun(@plus,means(:,k),X(:,ii));
    classf(ii) = k;
    ii = ii+N;
end

N = K*N;

% ---------------- define system -------------------


w=[];    
map = @(W) score_map(W,X);
transmap = @(Y) score_transmap(Y,X);
system = linTrans(w,map,transmap);
penalizer = sumsquares_penalty(w,1);

% ------------- train it ------------------------------

confusion = 0.01;
lambda = 0.01;

W0 = zeros(K,dim+1);
W = train_system(classf,system,penalizer,W0,lambda,confusion,20);

% ------------ plot log posterior on training data --------------------

scores = score_system(W,system,K);
scores = logsoftmax(scores);
subplot(1,2,1);plot(scores');


scores = score_system(W,system,K,true);
scores = [scores;zeros(1,N)];
scores = logsoftmax(scores);
subplot(1,2,2);plot(scores');
