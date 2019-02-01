function [y,deriv] = mce_obj(w,T,weights,logprior)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Weighted multiclass cross-entropy objective.
%   w is vectorized K-by-N score matrix W (to be optimized)
%   T is K-by-N, 0/1 class label matrix, with exactly one 1 per column.
%   weights is N-vector of objective function weights, one per trial.
%   logprior is logarithm of prior,

if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)mce_obj(w,T,weights,logprior);
    return;
end

if isa(w,'function_handle')
    outer = mce_obj([],T,weights,logprior);
    y = compose_mv(outer,w,[]);
    return;
end


w = w(:);

[K,N] = size(T);


scores = reshape(w,K,N);
scores = bsxfun(@plus,scores,logprior(:));

lsm = logsoftmax(scores); % K*N
y = -sum(lsm.*T)*weights(:);



deriv = @(dy) deriv_this(dy,lsm,T,weights);


function [g,hess,linear] = deriv_this(dy,lsm,T,weights)
sigma = exp(lsm); %posterior % K*N
g0 = gradient(sigma,T,weights);
g = dy*g0;
linear = false;
hess = @(d) hessianprod(d,dy,g0,sigma,weights);


function g = gradient(sigma,T,weights)
E = sigma-T; %K*N
G = bsxfun(@times,E,weights(:).'); %dim*K
g = G(:);


function [h,Jv] = hessianprod(d,dy,g0,sigma,weights)

K = size(sigma,1);
dim = length(d)/K;
P = reshape(d,K,dim);


sigmaP =   sigma.*P;
ssP = sum(sigmaP,1); % 1*N
sssP = bsxfun(@times,sigma,ssP); %K*N

h = bsxfun(@times,(sigmaP-sssP),weights(:).');  % dim*K
h = dy*h(:);

if nargout>1
    Jv = d.'*g0;
end


function test_this()
K = 3;
N = 30;
%T = [repmat([1;0;0],1,10),repmat([0;1;0],1,10),repmat([0;0;1],1,10)];
T = rand(K,N); T = bsxfun(@times,T,1./sum(T,1));
W = randn(K,N);
weights = rand(1,N);
f = @(w) mce_obj(w,T,weights,-1);
test_MV2DF(f,W(:));
