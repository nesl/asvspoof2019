function qual = seg_qual_to_qual(train_seg_qual,test_seg_qual)
% Merges two objects of type Seg_Quality to from an object of type
% Quality.  The train_seg_qual is used to create modelQ and
% modelset and the test_seg_qual is used to create segQ and
% segset. 
% Inputs:
%   train_seg_qual: An object of type Seg_Quality that contains the
%     quality measures for the models. 
%   test_seg_qual: An object of type Seg_Quality that contains the
%     quality measures for the test segments. 
% Outputs:
%   qual: An object of type Quality.

assert(nargin==2)
assert(isa(train_seg_qual,'Seg_Quality'))
assert(isa(test_seg_qual,'Seg_Quality'))
assert(train_seg_qual.validate())
assert(test_seg_qual.validate())

qual = Quality();

qual.modelset = train_seg_qual.ids;
qual.segset = test_seg_qual.ids;

qual.modelQ = train_seg_qual.values;
qual.segQ = test_seg_qual.values;

qual.hasmodel = true(1,length(qual.modelset));
qual.hasseg = true(1,length(qual.segset));
qual.scoremask = true(length(qual.modelset),length(qual.segset));

assert(qual.validate())

end
