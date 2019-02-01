function auc = area_under_rocch(pmiss,pfa)
% Calculates the area under the ROCCH (ROC convex hull) given the
% rocch co-ordinates.
% Inputs:
%   pmiss, pfa: vectors (with the same number of elements)
%     containing the ROCCH co-ordinates.
% Outputs:
%   auc: The area under the ROCCH.

assert(isvector(pmiss))
assert(isvector(pfa))
assert(issorted(pmiss))
assert(issorted(pfa(end:1)))
assert(length(pmiss)==length(pfa))

auc = 0;
for ii = 2:length(pmiss)
    auc = auc + 0.5 * (pmiss(ii) - pmiss(ii-1)) * (pfa(ii-1) + pfa(ii));
end

end
