function qual = merge(qual1,qual2)
% Merges two Seg_Quality objects.  The 'ids' lists of the two input
% objects must be disjoint.
% Inputs:
%   qual1: A Seg_Quality object.
%   qual2: Another Seg_Quality object.
% Outputs:
%   qual: A Seg_Quality object that contains the information from
%     the two input objects.

assert(nargin==2)
assert(isa(qual1,'Seg_Quality'))
assert(isa(qual2,'Seg_Quality'))
assert(qual1.validate())
assert(qual2.validate())

assert(isempty(intersect(qual1.ids,qual2.ids)))

qual = Seg_Quality();
qual.ids = {qual1.ids{:}, qual2.ids{:}};
qual.values = [qual1.values,qual2.values];

assert(qual.validate())
