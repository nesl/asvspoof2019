function y = probit(p)
% probit: The mapping from [0,1] to [-inf,inf] as used to make a DET out of
% an ROC.
%

assert(nargin==1)

y = sqrt(2) * erfinv(2*p - 1);
end
