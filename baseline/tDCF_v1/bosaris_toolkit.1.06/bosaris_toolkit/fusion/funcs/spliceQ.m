function qual = spliceQ(qual1,qual2,ndx)
% Combines two Quality objects.  The modelQ (segQ) quality measure
% vectors for each model (segment) are appended.  The output object
% is the intersection of the two input objects i.e. it only has a
% quality measure vector when both inputs have a vector for that
% model or segment.
% Inputs:
%   qual1: A Quality object.
%   qual2: Another Quality object.
%   ndx: A Key or Ndx object indicating trials.
% Outputs:
%   qual: A Quality object.  If qual1 has m quality measures for
%     each model and segment and qual2 has n, then qual will have
%     m+n quality measures for each (retained) model and segment.

% align so that quality measures for the same models and segments
% will be appended
assert(nargin==3)
assert(isa(qual1,'Quality'))
assert(isa(qual2,'Quality'))
assert(isa(ndx,'Key')||isa(ndx,'Ndx'))

qual1 = qual1.align_with_ndx(ndx);
qual2 = qual2.align_with_ndx(ndx);

% append quality measures
qual = Quality();
qual.modelQ = [qual1.modelQ;qual2.modelQ];
qual.segQ = [qual1.segQ;qual2.segQ];

% form the intersection
qual.hasmodel = qual1.hasmodel & qual2.hasmodel;
qual.hasseg = qual1.hasseg & qual2.hasseg;
qual.scoremask = qual1.scoremask & qual2.scoremask;

qual.modelset = ndx.modelset;
qual.segset = ndx.segset;
