function [new_pm,new_pfa] = filter_roc(pm,pfa)
% Removes redundant points from the sequence of points (pfa,pm) so
% that plotting an ROC or DET curve will be faster.  The output ROC
% curve will be identical to the one plotted from the input
% vectors.  All points internal to straight (horizontal or
% vertical) sections on the ROC curve are removed i.e. only the
% points at the start and end of line segments in the curve are
% retained.  Since the plotting code draws straight lines between
% points, the resulting plot will be the same as the original.
% Inputs:
%   pm, pfa: The coordinates of the vertices of the ROC Convex
%     Hull.  m for misses and fa for false alarms.
% Outputs:
%   new_pm, new_pfa: Vectors containing selected values from the
%     input vectors.  

assert(nargin==2)
assert(isvector(pm))
assert(isvector(pfa))

out = 1;
new_pm = pm(1);
new_pfa = pfa(1);

for i=2:length(pm)
    if (pm(i) == new_pm(out)) || (pfa(i) == new_pfa(out))
	continue
    end
    
    % save previous point, because it is the last point before the
    % change.  On the next iteration, the current point will be saved.
    out = out+1;
    new_pm(out) = pm(i-1);
    new_pfa(out) = pfa(i-1);
end

out = out+1;
new_pm(out) = pm(end);
new_pfa(out) = pfa(end);
