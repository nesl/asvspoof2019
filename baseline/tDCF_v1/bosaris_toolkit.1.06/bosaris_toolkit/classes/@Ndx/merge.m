function ndx = merge(param1,param2)
% ndx = merge(ndx_obj_array)
% ndx = merge(ndx1,ndx2)
% Merges Ndx objects.  The function can be called in two ways: with
% two ndxs or with an object array of ndxs.
% Inputs:
%   Either:
%   ndx1: An Ndx object.
%   ndx2: Another Ndx object.
%   Or:
%   ndx_obj_array: An array of Ndx objects.
% Outputs:
%   ndx: An Ndx object that contains the information from the input ndxs.

assert(nargin<3)
if nargin==2
    ndx1 = param1;
    ndx2 = param2;
    assert(isa(ndx1,'Ndx'))
    assert(isa(ndx2,'Ndx'))
    assert(ndx1.validate())
    assert(ndx2.validate())

    ndx_obj_arr = Ndx.empty(2,0);
    ndx_obj_arr(1) = ndx1;
    ndx_obj_arr(2) = ndx2;
    
    ndx = Ndx.merge(ndx_obj_arr);
else
    % the output ndx must have all models and segment in the input
    % ndxs (only once).  A trial in any ndx becomes a trial in the
    % output ndx.
    assert(nargin==1)
    obj_array = param1;
    assert(isa(obj_array,'Ndx'))
    numndxs = length(obj_array);
    ndx = Ndx();
    for ii=1:numndxs
	ndx_new = Ndx();
	ndx1 = ndx;
	ndx2 = obj_array(ii);
  
	% create new ndx with empty masks
	ndx_new.modelset = union(ndx1.modelset, ndx2.modelset);
	ndx_new.segset = union(ndx1.segset, ndx2.segset);

	% expand ndx1 mask
	trials_1 = false(length(ndx_new.modelset), length(ndx_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(ndx_new.modelset,ndx1.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(ndx_new.segset,ndx1.segset);
	trials_1(model_index_a,seg_index_a) = ndx1.trialmask(model_index_b,seg_index_b);

	% expand ndx2 mask
	trials_2 = false(length(ndx_new.modelset), length(ndx_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(ndx_new.modelset,ndx2.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(ndx_new.segset,ndx2.segset);
	trials_2(model_index_a,seg_index_a) = ndx2.trialmask(model_index_b,seg_index_b);

	% merge masks
	trials = trials_1 | trials_2;
	
	% build new ndx
	ndx_new.trialmask = trials;
	ndx = ndx_new;	
    end
end
	
	
assert(ndx.validate())
