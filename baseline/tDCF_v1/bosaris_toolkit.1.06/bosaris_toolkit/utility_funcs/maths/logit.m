function lp = logit(p)
% LOGIT: logit function.
%        This is a one-to-one mapping from probability to log-odds.
%        i.e. it maps the interval (0,1) to the real line.
%        The inverse function is given by SIGMOID.
%
%   log_odds = logit(p) = log(p/(1-p))

assert(nargin==1)

lp = zeros(size(p));
f0 = find(p==0);
f1 = find(p==1);
f = find((p>0)&(p<1));
lp(f) = log(p(f)./(1-p(f)));
lp(f0) = -inf;
lp(f1) = inf;
