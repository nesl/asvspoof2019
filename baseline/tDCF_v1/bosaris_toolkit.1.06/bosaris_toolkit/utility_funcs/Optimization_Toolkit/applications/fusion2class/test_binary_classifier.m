function obj_val = test_binary_classifier(objective_function,classf, ...
				  prior,system,input_data)
% Returns the result of the objective function evaluated on the
% scores.
%
% Inputs:
%   objective_function: a function handle to the objective function
%                       to feed the scores into
%   classf: length T vector where T is the number of trials with entries +1 for target scores; -1 
%           for non-target scores
%   prior: the prior (given to the system that produced the scores)
%   system: a function handle to the system to be run
%   input_data: the data to run the system on (to produce scores)
%
% Outputs
%   obj_val: the value returned by the objective function

if nargin==0
    test_this();
    return;
end

scores = system(input_data);
obj_val = evaluate_objective(objective_function,scores,classf,prior);

end

function test_this()

num_trials = 100;
input_data = randn(20,num_trials);

prior = 0.5;
maxiters = 1000;
classf = [ones(1,num_trials/2),-ones(1,num_trials/2)];
tar = input_data(:,1:num_trials/2);
non = input_data(:,num_trials/2+1:end);
[sys,run_sys,w0] = linear_fusion_factory(tar,non);

w = train_binary_classifier(@cllr_obj,classf,sys,[],w0,[],maxiters,[],prior,[],true);

system = @(data) run_sys(w,data);
test_binary_classifier(@cllr_obj,classf,prior,system,input_data)


end

