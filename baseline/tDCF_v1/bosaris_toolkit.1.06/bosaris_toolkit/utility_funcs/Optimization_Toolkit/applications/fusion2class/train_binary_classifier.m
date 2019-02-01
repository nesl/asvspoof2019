function [w,cxe,w_pen,optimizerState,converged] = ...
    train_binary_classifier(classifier,classf,w0,objective_function,prior,...
                            penalizer,lambda,maxiters,maxCG,optimizerState,...
                            quiet,cstepHessian)
% 
%   Supervised training of a regularized fusion.
%
%
% Inputs:
%
%   classifier: MV2DF function handle that maps parameters to llr-scores.
%               Note: The training data is already wrapped in this handle.
%
%   classf: 1-by-N row of class labels: 
%                -1 for non_target, 
%                +1 for target, 
%                 0 for ignore
%
%   w0: initial parameters. This is NOT optional. 
%
%   objective_function: A function handle to an Mv2DF function that
%                       maps the output (llr-scores) of classifier, to 
%                       the to-be-minimized objective (called cxe).  
%                       optional, use [] to invoke 'cllr_obj'.
%   
%  prior: a prior probability for target to set the 'operating point' 
%         of the objective function.
%         optional: use [] to invoke default of 0.5
%
%  penalizer: MV2DF function handle that maps parameters to a positive 
%              regularization penalty.
%
%  lambda: a weighting for the penalizer
%           
%  maxiters: the maximum number of Newton Trust Region optimization
%            iterations to perform. Note, the user can make maxiters
%            small, examine the solution and then continue training:
%            -- see w0 and optimizerState.
%
%
%
%  optimizerState: In this implementation, it is the trust region radius.
%                  optional: 
%                    omit or use []
%                    If not supplied when resuming iteration,
%                    this may cost some extra iterations. 
%                  Resume further iteration thus:
%   [w1,...,optimizerState] = train_binary_classifier(...);
%   ... examine solution w1  ...
%   [w2,...,optimizerState] = train_binary_classifier(...,w1,...,optimizerState);
%                
%
%  quiet: if false, outputs more info during training
%
%
%  Outputs:
%    w: the solution. 
%    cxe: normalized multiclass cross-entropy of the solution. 
%         The range is 0 (good) to 1(useless).
%
%    optimizerState: see above, can be used to resume iteration.
%  


if nargin==0
    test_this();
    return;
end


if ~exist('maxCG','var') || isempty(maxCG)
    maxCG = 100;
end


if ~exist('optimizerState','var')
    optimizerState=[];
end

if ~exist('prior','var') || isempty(prior)
    prior = 0.5;
end

if ~exist('objective_function','var') || isempty(objective_function)
    objective_function = @(w,T,weights,logit_prior) cllr_obj(w,T,weights,logit_prior);
end

%prior_entropy = -prior*log(prior)-(1-prior)*log(1-prior);
prior_entropy = objective_function([0;0],[1,-1],[prior,1-prior],logit(prior));

classf = classf(:)';

ntar = length(find(classf>0));
nnon = length(find(classf<0));
N = nnon+ntar;

weights = zeros(size(classf));
weights(classf>0) = prior/(ntar*prior_entropy);
weights(classf<0) = (1-prior)/(nnon*prior_entropy);
%weights remain 0, where classf==0


w=[];    

if exist('penalizer','var') && ~isempty(penalizer)
    obj1 = objective_function(classifier,classf,weights,logit(prior));
    obj2 = penalizer(w);
    obj = sum_of_functions(w,[1,lambda],obj1,obj2);
else
    obj = objective_function(classifier,classf,weights,logit(prior));
end

w0 = w0(:);

if exist('cstepHessian','var') &&~ isempty(cstepHessian)
    obj = replace_hessian([],obj,cstepHessian);
end

[w,y,optimizerState,converged] = trustregion_newton_cg(obj,w0,maxiters,maxCG,optimizerState,[],1,quiet);

if exist('penalizer','var') && ~isempty(penalizer)
    w_pen = lambda*obj2(w);
else
    w_pen = 0;
end


cxe = y-w_pen;
if ~quiet
    fprintf('cxe = %g, pen = %g\n',cxe,w_pen);
end




function test_this()

%invoke test for linear_fuser, which calls train_binary_classifier
linear_fuser();
