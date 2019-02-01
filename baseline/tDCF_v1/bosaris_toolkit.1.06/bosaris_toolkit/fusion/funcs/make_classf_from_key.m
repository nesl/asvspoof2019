function classf = make_classf_from_key(key)
% Create a classf vector (for use in fusion functions) from a key.
% Inputs:
%   key: A Key object indicating target and non-target trials.
% Outputs:
%   classf: A vector containing 1s to indicate target trials, -1s to
%     indicate non-target trials and 0s to indicate trials to be ignored.

assert(nargin==1)
assert(isa(key,'Key'))

trials = key.tar(:)' | key.non(:)';
tar = key.tar(trials);
tar = tar(:)';
non = key.non(trials);
non = non(:)';
numtrials = sum(trials);
classf = zeros(1,numtrials);
classf(tar) = 1;
classf(non) = -1;

