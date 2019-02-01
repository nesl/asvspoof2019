function [f,nxe_train,w] = train_linear_calibration(tar,non,prior,obj_func,niters,quiet)
% A function that uses 'train_binary_classifier' to train a linear
% fusion function.
% Inputs:
%   tar: a vector of scores for target trials
%   non: a vector of scores for non-target trials
%   prior: the effective target prior
%   obj_func: the objective function for the training algorithm.  If []
%     then cllr objective is used.
%   niters: The maximum number of training iterations
%   quiet: A boolean indicating whether the training algorithm
%     should print information on its progress.
% Outputs:
%   f: A function handle to the trained calibration function.
%     f(scores) will return a vector of the same length as scores
%       with each score scaled and shifted according to the values
%       learned during training.
%   nxe_train: normalized multiclass cross-entropy of the solution. 
%       The range is 0 (good) to 1 (useless).
%   w: The calibration weigths (scale factor and offset).

% check the inputs
assert(nargin==6)
assert(size(tar,1)==1)
assert(size(non,1)==1)
assert(length(tar)>0)
assert(length(non)>0)

% create function handle for function that must be trained
[fusion,params] = linear_fuser([],[tar,non]);
% get a starting point for the calibration weights: 'w0'
w0 = params.get_w0();
% let the trainer know which scores are target scores and which are
% non-target scores
classf = [ones(1,length(tar)),-ones(1,length(non))];
% do the training to get the calibration weights 'w'
[w,nxe_train] = train_binary_classifier(fusion,classf,w0,obj_func,prior,[],0,niters,[],[],quiet);

% create a function handle that will calibrate input scores using
% the trained weights 'w'
f = @(scores) linear_fuser(w,scores);
