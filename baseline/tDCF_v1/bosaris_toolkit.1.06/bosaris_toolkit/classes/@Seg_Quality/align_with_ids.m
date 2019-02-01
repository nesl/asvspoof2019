function aligned_qual = align_with_ids(qual,refids)
% The ordering of the ids in the output Seg_Quality object
% corresponds to refids, so aligning several Seg_Quality objects with
% the same refids will result in them being comparable with each other.
% Inputs:
%   qual: a Seg_Quality object
%   refids: a cell array of strings
% Outputs:
%   aligned_qual: qual with ids resized to size of 'refids' and reordered
%     according to refids.

assert(nargin==2)
assert(isa(qual,'Seg_Quality'))
assert(iscell(refids))
assert(qual.validate())

innumids = length(qual.ids);
numrefids = length(refids);

aligned_qual = Seg_Quality();
aligned_qual.ids = refids;

[hasid,rindx] = ismember(refids,qual.ids);
rindx = rindx(hasid);

q = size(qual.values,1);

assert(all(isfinite(qual.values(:))))
  
aligned_qual.values = zeros(q,numrefids);
aligned_qual.values(:,hasid) = qual.values(:,rindx);

lost = innumids - numrefids;

if lost > 0
    log_warning('Number of segments reduced from %i to %i\n',innumids,numrefids)
end

usedids = sum(hasid);

if usedids < numrefids
    log_warning('%i of %i ids don''t have quality values\n',numrefids-usedids,numrefids)
end

assert(aligned_qual.validate())

end
