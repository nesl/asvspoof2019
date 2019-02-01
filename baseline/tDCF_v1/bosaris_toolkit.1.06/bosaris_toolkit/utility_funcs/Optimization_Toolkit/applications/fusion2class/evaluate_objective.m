function obj_val = evaluate_objective(objective_function,scores,classf, ...
				  prior)
% Returns the result of the objective function evaluated on the
% scores.
%
% Inputs:
%   objective_function: a function handle to the objective function
%                       to feed the scores into
%   scores: length T vector of scores to be evaluated where T is
%           the number of trials
%   classf: length T vector with entries +1 for target scores; -1 
%           for non-target scores
%   prior: the prior (given to the system that produced the scores)
%
% Outputs
%   obj_val: the value returned by the objective function

if nargin==0
    test_this();
    return;
end


if ~exist('objective_function','var') || isempty(objective_function)
    objective_function = @(w,T,weights,logit_prior) cllr_obj(w,T,weights,logit_prior);
end


logit_prior = logit(prior);
prior_entropy = objective_function([0;0],[1,-1],[prior,1-prior],logit_prior);

ntar = length(find(classf>0));
nnon = length(find(classf<0));
N = nnon+ntar;

weights = zeros(1,N);

weights(classf>0) = prior/(ntar*prior_entropy);
weights(classf<0) = (1-prior)/(nnon*prior_entropy);


obj_val = objective_function(scores,classf,weights,logit_prior);

end

function test_this()
num_trials = 20;
scores = randn(1,num_trials);
classf = [ones(1,num_trials/2),-ones(1,num_trials/2)];
prior = 0.5;
res = evaluate_objective(@cllr_obj,scores,classf,prior)
end

