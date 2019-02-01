function [y,deriv] = cllr_obj(w,T,weights,logit_prior)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Weighted binary classifier cross-entropy objective, based on logarithmic
% cost function.
%
%  Differentiable inputs:
%   w: is vector of N detection scores (in log-likelihood-ratio format) 
%
%  Fixed parameters:
%   T: is vector of N labels: 1 for target and -1 for non-target.
%   weights: is N-vector of objective function weights, one per trial.
%   logit_prior: is logit(prior), this controls the region of interest

if nargin==0
    test_this();
    return;
end

if isempty(w)
    y = @(w)cllr_obj(w,T,weights,logit_prior);
    return;
end

if isa(w,'function_handle')
    outer = cllr_obj([],T,weights,logit_prior);
    y = compose_mv(outer,w,[]);
    return;
end


w = w(:);
scores = w.';
arg = bsxfun(@plus,scores,logit_prior).*T;
neglogp1 = neglogsigmoid(arg); % 1*N           p1 = p(tar)
y = neglogp1*weights(:);



if nargout>1
    neglogp2 = neglogsigmoid(-arg); % 1*N      p2 = 1-p1 = p(non)
    deriv = @(dy) deriv_this(dy,-neglogp1(:),-neglogp2(:),T(:),weights(:));
end


function [g,hess,linear] = deriv_this(dy,logp1,logp2,T,weights)
g0 = -exp(logp2).*weights.*T;
g = dy*g0;
linear = false;
hess = @(d) hessianprod(d,dy,g0,logp1,logp2,weights);




function [h,Jv] = hessianprod(d,dy,g0,logp1,logp2,weights)

h = dy*(exp(logp1+logp2).*weights(:).*d(:));


if nargout>1
    Jv = d.'*g0;
end


function test_this()
N = 30;
T = [ones(1,N/3),-ones(1,N/3),zeros(1,N/3)];
W = randn(1,N);
weights = [rand(1,2*N/3),zeros(1,N/3)];
f = @(w) cllr_obj(w,T,weights,-2.23);
test_MV2DF(f,W(:));
