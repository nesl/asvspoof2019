function [y,deriv] = brier_obj(w,T,weights,logit_prior)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Weighted binary classifier cross-entropy objective, based on 'Brier'
% quadratic proper scoring rule. This rule places less emphasis on extreme scores,
% than the logariothmic scoring rule.
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
    y = @(w)brier_obj(w,T,weights,logit_prior);
    return;
end

if isa(w,'function_handle')
    outer = brier_obj([],T,weights,logit_prior);
    y = compose_mv(outer,w,[]);
    return;
end


w = w(:);
scores = w.';

arg = bsxfun(@plus,scores,logit_prior).*T;
logp2 = -neglogsigmoid(-arg);
wobj = 0.5*exp(2*logp2).*weights; % 1*N
y = sum(wobj);



if nargout>1
    logp1 = -neglogsigmoid(arg);
    deriv = @(dy) deriv_this(dy,weights(:),T(:),logp1(:),logp2(:));
end


function [g,hess,linear] = deriv_this(dy,weights,T,logp1,logp2)
g0 = -exp(logp1+2*logp2).*weights.*T;
g = dy*g0;
linear = false;
hess = @(d) hessianprod(d,dy,g0,weights,logp1,logp2);




function [h,Jv] = hessianprod(d,dy,g0,weights,logp1,logp2)

ddx = -exp(logp1+2*logp2);
h = dy*(ddx.*(1-3*exp(logp1))).*weights.*d(:);

if nargout>1
    Jv = d.'*g0;
end


function test_this()
N = 30;
T = [ones(1,N/3),-ones(1,N/3),zeros(1,N/3)];
scores = randn(1,N);
weights = [rand(1,2*N/3),zeros(1,N/3)];
f = @(w) brier_obj(w,T,weights,-2.23);
test_MV2DF(f,scores(:));
