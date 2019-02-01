function scores = score_system(W,system,K,for_linear_backend)

% Compute scores, using W-matrix as trained by train_mclr
% Inputs:
% 
%   W: system parameters
%
%   system: function handle that maps parameters to scores 
%           (input data is wrapped in handle)
%
%   K: number of classes
%
%   for_linear_backend: if true, will remove linear dependency from scores
%                       by zero-ing last score and removing the zeros.
%
%  Outputs:
%
%    scores: K-by-N,       if for_linear_backend = false.
%            (K-1)-by-N,   if for_linear_backend = true, in which case
%                          the K-th log-likelihood is 0 for every trial.


if nargin==0
    fprintf('do test of "train_system" to also test this function\n');
    return;
end

if nargin<4
    for_linear_backend = false;
end

scores = system(W);
scores = reshape(scores,K,[]);

if for_linear_backend
    scores = bsxfun(@minus,scores,scores(end,:));
    scores(end,:) = [];
end
