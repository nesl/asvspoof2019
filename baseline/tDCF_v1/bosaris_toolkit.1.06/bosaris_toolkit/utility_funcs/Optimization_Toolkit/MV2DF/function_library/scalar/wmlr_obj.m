function [y,deriv] = wmlr_obj(w,X,T,weights,logprior);
% This is a SCAL2DF. See SCAL2DF_API_DEFINITION.readme.
% Weighted multiclass linear logistic regression objective function.
%   w is vectorized D-by-K parameter matrix W (to be optimized)
%   X is D-by-N data matrix, for N trials
%   T is K-by-N, 0/1 class label matrix, with exactly one 1 per column.
%   weights is N-vector of objective function weights, one per trial.
%   logprior is logarithm of prior,
%
%   The K-by-N log-likelihood matrix is
%     bsxfun(@plus,W'*X,logprior(:));


if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)wmlr_obj(w,X,T,weights,logprior);
    return;
end

if isa(w,'function_handle')
    outer = wmlr_obj([],X,T,weights,logprior);
    y = compose_mv(outer,w,[]);
    return;
end


w = w(:);

[K,N] = size(T);
[dim,N2] = size(X);
if N ~=N2
    error('sizes of X and T incompatible');
end

W = reshape(w,dim,K); % dim*K
% make W double so that it works if X is sparse
scores = double(W.')*X; % K*N
scores = bsxfun(@plus,scores,logprior(:));

lsm = logsoftmax(scores); % K*N
y = -sum(lsm.*T)*weights(:);
deriv = @(dy) deriv_this(dy,lsm,X,T,weights);


function [g,hess,linear] = deriv_this(dy,lsm,X,T,weights)
sigma = exp(lsm); %posterior % K*N
g0 = gradient(sigma,X,T,weights);
g = g0*dy;
hess = @(d) hess_this(d,dy,g0,sigma,X,weights);
linear = false;

function g = gradient(sigma,X,T,weights)
E = sigma-T; %K*N
G = X*double(bsxfun(@times,weights(:),E.')); %dim*K
g = G(:);


function [h,Jv] = hess_this(d,dy,g,sigma,X,weights)

K = size(sigma,1);
dim = length(d)/K;
D = reshape(d,dim,K);

P = double(D.')*X; % K*N
sigmaP =   sigma.*P;
ssP = sum(sigmaP,1); % 1*N
sssP = bsxfun(@times,sigma,ssP); %K*N

h = X*double(bsxfun(@times,weights(:),(sigmaP-sssP).'));  % dim*K
h = dy*h(:);

if nargout>1
    Jv = d(:).'*g;
end


if nargin==0
    test_this();
    return;
end


function test_this()


K = 3;
N = 100;
dim = 2;
randn('state',0);
means = randn(dim,K)*10; %signal
X0 = randn(dim,K*N); % noise
classf = zeros(1,K*N);
ii = 1:N;
T = zeros(K,N*K);
for k=1:K
    X0(:,ii) = bsxfun(@plus,means(:,k),X0(:,ii));
    classf(ii) = k;
    T(k,ii) = 1;
    ii = ii+N;
end

N = K*N;
X = [X0;ones(1,N)];

weights = rand(1,N);
obj = wmlr_obj([],X,T,weights,2);

test_MV2DF(obj,randn((dim+1)*K,1));
