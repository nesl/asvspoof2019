% This is code to test QUALITY FUSION V1
%
% Synthetic data for two classes is generated with gaussian noise, but then
% the noise amplitude is modulated with a random amplitude for every trial.
% The random amplitude is the distance of a random vector from the origin.
% These random vectors are embedded in a higher dimension, with some extra
% high-dimensional noise and this high-dimensional data is provided to the
% algorithm as quality data. 
%
% This code compares a plain linear classifier with QUALITY FUSION V1.


randn('state',0);
rand('twister',5489);

dim = 10;
means = 2.5*randn(dim,2);

qdim = 5;
rdim = 2;
H = 5*randn(qdim,rdim);

N = 10000;
[train_scores,train_aux1,train_aux2,classf] = synth_scores_with_quality(means,H,N);

[fusion,params] = linear_fuser([],train_scores);
w0 = params.get_w0();

obj = @(w,T,weights,logit_prior) cllr_obj(w,T,weights,logit_prior);
quiet = true;
prior = 0.5;
[w,cllr_train] = train_binary_classifier(fusion,classf,w0,obj,prior,[],0,50,[],[],quiet),


[test_scores,test_aux1,test_aux2,classf] = synth_scores_with_quality(means,H,N);
llr = linear_fuser(w,test_scores);
cllr_test = evaluate_objective(obj,llr,classf,prior)

%return;

ndx = 1:N;
ddim = rdim;
[fusion,params] = quality_fuser_v1([],train_scores,train_aux1,train_aux2,ndx,ndx,ddim);
ssat = 0.01;
w0 = params.get_w0(ssat);
quiet = false;
[w,cllr_train] = train_binary_classifier(fusion,classf,w0,obj,prior,[],0,50,[],[],quiet),
llr = quality_fuser_v1(w,test_scores,test_aux1,test_aux2,ndx,ndx,ddim);
cllr_test = evaluate_objective(obj,llr,classf,prior)

