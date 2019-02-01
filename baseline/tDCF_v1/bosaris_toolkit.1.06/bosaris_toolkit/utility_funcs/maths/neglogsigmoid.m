function neg_log_p = neglogsigmoid(log_odds)
% neg_log_p = NEGLOGSIGMOID(log_odds)
%   This is mathematically equivalent to -log(sigmoid(log_odds)), 
%   but numerically better, when log_odds is large negative          

assert(nargin==1)

neg_log_p = -log_odds;
e = exp(-log_odds);
f=find(e<e+1);
neg_log_p(f) = log(1+e(f));
