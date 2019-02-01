function [y,deriv] = boost_obj(w,T,weights,logit_prior)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% Weighted binary classifier cross-entropy objective, based on 'boosting'
% proper scoring rule. This rule places more emphasis on extreme scores,
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
    y = @(w)boost_obj(w,T,weights,logit_prior);
    return;
end

if isa(w,'function_handle')
    outer = boost_obj([],T,weights,logit_prior);
    y = compose_mv(outer,w,[]);
    return;
end


w = w(:);
scores = w.';
arg = bsxfun(@plus,scores,logit_prior).*T;
wobj = exp(-arg/2).*weights; % 1*N
y = sum(wobj);



if nargout>1
    deriv = @(dy) deriv_this(dy,wobj(:),T);
end


function [g,hess,linear] = deriv_this(dy,wobj,T)
g0 = -0.5*wobj.*T(:);
g = dy*g0;
linear = false;
hess = @(d) hessianprod(d,dy,g0,wobj);




function [h,Jv] = hessianprod(d,dy,g0,wobj)

h = dy*(0.25*wobj(:).*d(:));


if nargout>1
    Jv = d.'*g0;
end


function test_this()
N = 30;
T = [ones(1,N/3),-ones(1,N/3),zeros(1,N/3)];
scores = randn(1,N);
weights = [rand(1,2*N/3),zeros(1,N/3)];
f = @(w) brier_obj(w,T,weights,-2.23);
f = @(w) boost_obj(w,T,weights,-2.23);
test_MV2DF(f,scores(:));
