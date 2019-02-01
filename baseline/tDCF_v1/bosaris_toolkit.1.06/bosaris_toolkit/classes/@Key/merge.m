function key = merge(param1,param2)
% key = merge(key_obj_array)
% key = merge(key1,key2)
% Merges Key objects.  The function can be called in two ways: with
% two keys or with an object array of keys.
% Inputs:
%   Either:
%   key1: A Key object.
%   key2: Another Key object.
%   Or:
%   key_obj_array: An array of Key objects.
% Outputs:
%   key: A Key object that contains the information from the input keys.

assert(nargin<3)
if nargin==2
    key1 = param1;
    key2 = param2;
    assert(isa(key1,'Key'))
    assert(isa(key2,'Key'))
    assert(key1.validate())
    assert(key2.validate())

    key_obj_arr = Key.empty(2,0);
    key_obj_arr(1) = key1;
    key_obj_arr(2) = key2;
    key = Key.merge(key_obj_arr);
   
else
    % the output key must have all models and segment in the input
    % keys (only once) and the same target and non-target trials.
    % It is an error if a trial is a target in one key and a
    % non-target in another, but a target or non-target marker will
    % override a 'non-trial' marker.
    assert(nargin==1)
    obj_array = param1;
    assert(isa(obj_array,'Key'))
    numkeys = length(obj_array);
    key = Key();
    for ii=1:numkeys
	key_new = Key();
	key1 = key;
	key2 = obj_array(ii);
	
	% create new key with empty masks
	key_new.modelset = union(key1.modelset, key2.modelset);
	key_new.segset = union(key1.segset, key2.segset);

	% expand key1 masks
	targets_1 = false(length(key_new.modelset), length(key_new.segset));
	nontargets_1 = false(length(key_new.modelset), length(key_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(key_new.modelset,key1.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(key_new.segset,key1.segset);
	targets_1(model_index_a,seg_index_a) = key1.tar(model_index_b,seg_index_b);
	nontargets_1(model_index_a,seg_index_a) = key1.non(model_index_b,seg_index_b);

	% expand key2 masks
	targets_2 = false(length(key_new.modelset), length(key_new.segset));
	nontargets_2 = false(length(key_new.modelset), length(key_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(key_new.modelset,key2.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(key_new.segset,key2.segset);
	targets_2(model_index_a,seg_index_a) = key2.tar(model_index_b,seg_index_b);
	nontargets_2(model_index_a,seg_index_a) = key2.non(model_index_b,seg_index_b);

	% merge masks
	targets = targets_1 | targets_2;
	nontargets = nontargets_1 | nontargets_2;	
	
	% check for clashes
	assert(sum(targets(:)&nontargets(:))==0)
	
	% build new key
	key_new.tar = targets;
	key_new.non = nontargets;
	key = key_new;	
    end
end

assert(key.validate())
