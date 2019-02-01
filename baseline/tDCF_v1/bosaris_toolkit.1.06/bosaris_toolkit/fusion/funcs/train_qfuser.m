function [f,nxe_train,w] = train_qfuser(scores,scrQ,key,quiet,w0,cstepHessian,niters,obj_func,prior)
% Trains a linear fusion of scores with quality measures starting
% from the linear fusion of the only the scores.
% Inputs:
%   scores: A matrix of dev scores where the number of rows is the
%     number of systems to be fused and the number of columns
%     is the number of scores.
%   scrQ: An object of type Quality containing the quality measures
%     for the dev trials.
%   key: A Key object indicating target and non-target trials.
%   quiet: Boolean.  If true, the training algorithm outputs fewer
%     messages describing its progress.
%   w0: The fusion weights from the linear (without quality) fusion
%     step. 
%   cstepHessian: Boolean.  If true, the training algorithm will
%     calculate the Hessian matrix using complex step
%     differentiation which should make training faster.
%   niters: The maximum number of training iterations.
%   obj_func: The objective function for the fusion training.  If [],
%     cllr objective is used.
%   prior: The effective target prior.
% Outputs:
%   f: A function handle for the trained fusion function (of type qfuser_backoff).
%   nxe_train: The normalized cross-entropy of the solution found
%     when training the fusion weights.
%   w: The fusion weights found by the trainer.

assert(nargin==9)
assert(isa(key,'Key'))

trials = key.tar(:)' | key.non(:)';
n1 = size(scores,2);
n2 = sum(trials);
assert(n1==n2,'# score trials = %i, but # key trials = %i',n1,n2)

% dump bad trials
validscores = scrQ.scoremask(trials);
if sum(trials)-sum(validscores)>0
    log_warning('Quality fusion training has %i missing trials.\n',sum(trials)-sum(validscores));
end
scores = scores(:,validscores);
  
% remove models and segs without quality measures from key (and the
% corresponding trials)
key.modelset = key.modelset(scrQ.hasmodel);
key.segset = key.segset(scrQ.hasseg);
key.tar = key.tar(scrQ.hasmodel,scrQ.hasseg);
key.non = key.non(scrQ.hasmodel,scrQ.hasseg);
trials = key.tar(:)' | key.non(:)';
    
% also remove them from scrQ
scrQ.modelset = scrQ.modelset(scrQ.hasmodel);
scrQ.segset = scrQ.segset(scrQ.hasseg);
scrQ.scoremask = scrQ.scoremask(scrQ.hasmodel,scrQ.hasseg);
scrQ.modelQ = scrQ.modelQ(:,scrQ.hasmodel);
scrQ.segQ = scrQ.segQ(:,scrQ.hasseg);

scrQ.hasmodel = scrQ.hasmodel(scrQ.hasmodel);
scrQ.hasseg = scrQ.hasseg(scrQ.hasseg);
  
assert(size(scores,2)==sum(trials));

% set up function that must be trained
[fusion,w0] = qfuser_linear([],scores,scrQ,key,w0);

% Create vector that classifies scores as target/non-target
tar = key.tar(trials);
tar = tar(:)';
non = key.non(trials);
non = non(:)';
classf = zeros(1,size(scores,2));
classf(tar) = 1;
classf(non) = -1;
% rest is zero and will be ignored

% train the fusion weights
[w,nxe_train] = train_binary_classifier(fusion,classf,w0,obj_func,prior,[],0,niters,[],[],quiet,cstepHessian);

% create function handle to do fusion using trained weights
f = @(scores,scrQ,key,backoff_scores) qfuser_backoff(w,scores,scrQ,key,backoff_scores);
