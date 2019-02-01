function [f,nxe_train,w] = train_linear_fuser(scores,classf,prior,cstepHessian,quiet,niters,obj_func)
% Trains a function to do linear fusion of scores.  No quality
% measures are involved.  
% Inputs:
%   scores: A matrix of scores where the number of rows is the
%     number of systems to be fused and the number of columns
%     is the number of scores.
%   classf: A vector containing 1s to indicate target trials, -1s to
%     indicate non-target trials and 0s to indicate trials to be ignored.
%   prior: The effective target prior.
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
% Outputs:
%   f: A function handle for the trained fusion function.  This
%     function takes a matrix of scores as input where the number
%     of rows is the number of systems to be fused and the number
%     of columns is the number of scores.  It outputs a vector of
%     length number-of-scores.
%   nxe_train: The normalized cross-entropy of the solution found
%     when training the fusion weights.
%   w: The fusion weights found by the trainer.

assert(nargin==7)

% create function that must be trained
[fusion,params] = linear_fuser([],scores);

% create initial weights.  All zero didn't work, hence this initialization.
w0 = make_initial_fusion_weights(params);

% train the fusion weights
[w,nxe_train] = train_binary_classifier(fusion,classf,w0,obj_func,prior,[],0,niters,[],[],quiet,cstepHessian);

% create function handle to function that will do the fusion using
% the trained weights.
f = @(scores) linear_fuser(w,scores);
