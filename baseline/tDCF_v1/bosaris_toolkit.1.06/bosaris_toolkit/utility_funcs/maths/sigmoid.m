function p = sigmoid(log_odds)
% SIGMOID: Inverse of the logit function.
%          This is a one-to-one mapping from log odds to probability. 
%          i.e. it maps the real line to the interval (0,1).
%
%   p = sigmoid(log_odds)

assert(nargin==1)

p = 1 ./ (1 + exp(-log_odds));
