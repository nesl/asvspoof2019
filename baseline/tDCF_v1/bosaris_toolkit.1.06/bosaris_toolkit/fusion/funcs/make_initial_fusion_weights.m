function w0 = make_initial_fusion_weights(params)
% Produces initial weights for training the fusion.
% Inputs:
%   params: parameters of the untrained linear fusion function.
% Outputs:
%   w0: The initial fusion weights to be given to the trainer.

assert(nargin==1)

% create initial weights.  All zero didn't work, hence this initialization.
w0 = params.get_w0();
w0(:) = 1 ./ (length(w0)-1);
w0(end) = 0;

