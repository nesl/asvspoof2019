function [ghat,width,height] = pavx(y)
%PAV: Pool Adjacent Violators algorithm. Non-paramtetric optimization subject to monotonicity.
%
% ghat = pav(y)
% fits a vector ghat with nondecreasing components to the 
% data vector y such that sum((y - ghat).^2) is minimal. 
% (Pool-adjacent-violators algorithm).
%
% optional outputs:
%   width: width of pav bins, from left to right 
%          (the number of bins is data dependent)
%   height: corresponding heights of bins (in increasing order)
% 
% Author: This code is a simplified version of the 'IsoMeans.m' code made available 
% by Lutz Duembgen at:
% http://www.imsv.unibe.ch/~duembgen/software

assert(nargin==1)
assert(isvector(y))

n = length(y);
assert(n>0)
index = zeros(size(y));
len = zeros(size(y));
% An interval of indices is represented by its left endpoint 
% ("index") and its length "len" 
ghat = zeros(size(y));

ci = 1;
index(ci) = 1;
len(ci) = 1;
ghat(ci) = y(1);
% ci is the number of the interval considered currently.
% ghat(ci) is the mean of y-values within this interval.
for j=2:n
    % a new index intervall, {j}, is created:
    ci = ci+1;
    index(ci) = j;
    len(ci) = 1;
    ghat(ci) = y(j);
    while ci >= 2 && ghat(max(ci-1,1)) >= ghat(ci)
	% "pool adjacent violators":
	nw = len(ci-1) + len(ci);
	ghat(ci-1) = ghat(ci-1) + (len(ci) / nw) * (ghat(ci) - ghat(ci-1));
	len(ci-1) = nw;
	ci = ci-1;
    end
end

height = ghat(1:ci);
width = len(1:ci);

% Now define ghat for all indices:
while n >= 1
    for j=index(ci):n
	ghat(j) = ghat(ci);
    end
    n = index(ci)-1;
    ci = ci-1;
end
