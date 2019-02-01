function [Pmiss, Pfa] = compute_roc(true_scores, false_scores)
%  compute_roc computes the (observed) miss/false_alarm probabilities
%  for a set of detection output scores.
%
%  true_scores (false_scores) are detection output scores for a set of
%  detection trials, given that the target hypothesis is true (false).
%          (By convention, the more positive the score,
%          the more likely is the target hypothesis.)
%
% this code is matlab-tized for speed.
% speedup: Old routine 54 secs -> new routine 5.71 secs.
% for 109776 points.

%-------------------------
%Compute the miss/false_alarm error probabilities

assert(nargin==2)
assert(isvector(true_scores))
assert(isvector(false_scores))

num_true = length(true_scores);
num_false = length(false_scores);
assert(num_true>0)
assert(num_false>0)

total=num_true+num_false;

Pmiss = zeros(num_true+num_false+1, 1); %preallocate for speed
Pfa   = zeros(num_true+num_false+1, 1); %preallocate for speed

scores(1:num_false,1) = false_scores;
scores(1:num_false,2) = 0;
scores(num_false+1:total,1) = true_scores;
scores(num_false+1:total,2) = 1;

scores=DETsort(scores);

sumtrue=cumsum(scores(:,2),1);
sumfalse=num_false - ([1:total]'-sumtrue);

Pmiss(1) = 0;
Pfa(1) = 1.0;
Pmiss(2:total+1) = sumtrue  ./ num_true;
Pfa(2:total+1)   = sumfalse ./ num_false;

end


function [y,ndx] = DETsort(x,col)
% DETsort Sort rows, the first in ascending, the remaining in decending
% thereby postponing the false alarms on like scores.
% based on SORTROWS

if nargin<1, error('Not enough input arguments.'); end
if ndims(x)>2, error('X must be a 2-D matrix.'); end

if nargin<2, col = 1:size(x,2); end
if isempty(x), y = x; ndx = []; return, end

ndx = (1:size(x,1))';

% sort 2nd column ascending
[v,ind] = sort(x(ndx,2));
ndx = ndx(ind);

% reverse to decending order
ndx(1:size(x,1)) = ndx(size(x,1):-1:1);

% now sort first column ascending
[v,ind] = sort(x(ndx,1));
ndx = ndx(ind);
y = x(ndx,:);

end
