function scr = merge(param1,param2)
% scr = merge(scr_obj_array)
% scr = merge(scr1,scr2)
% Merges Scores objects.  The function can be called in two ways: with
% two Scores objects or with an object array of Scores.
% Inputs:
%   Either:
%   scr1: A Scores object.
%   scr2: Another Scores object.
%   Or:
%   scr_obj_array: An array of Scores objects.
% Outputs:
%   scr: A Scores object that contains the information from the
%     input Scores objects.

assert(nargin<3)
if nargin==2
    scr1 = param1;
    scr2 = param2;
    assert(isa(scr1,'Scores'))
    assert(isa(scr2,'Scores'))
    assert(scr1.validate())
    assert(scr2.validate())

    scr_obj_arr = Scores.empty(2,0);
    scr_obj_arr(1) = scr1;
    scr_obj_arr(2) = scr2;
    scr = Scores.merge(scr_obj_arr);
    
else
    % the output scr must have all models and segment in the input
    % scrs (only once) and the union of all the scoremasks.
    % It is an error if two of the input Scores objects have a
    % score for the same trial.
    assert(nargin==1)
    obj_array = param1;
    assert(isa(obj_array,'Scores'))
    numscrs = length(obj_array);
    scr = Scores();
    for ii=1:numscrs
	scr_new = Scores();
	scr1 = scr;
	scr2 = obj_array(ii);
	
	% create new scr with empty matrices
	scr_new.modelset = union(scr1.modelset, scr2.modelset);
	scr_new.segset = union(scr1.segset, scr2.segset);

	% expand scr1 matrices
	scoremat_1 = zeros(length(scr_new.modelset), length(scr_new.segset));
	scoremask_1 = false(length(scr_new.modelset), length(scr_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(scr_new.modelset,scr1.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(scr_new.segset,scr1.segset);
	scoremat_1(model_index_a,seg_index_a) = scr1.scoremat(model_index_b,seg_index_b);
	scoremask_1(model_index_a,seg_index_a) = scr1.scoremask(model_index_b,seg_index_b);

	% expand scr2 matrices
	scoremat_2 = zeros(length(scr_new.modelset), length(scr_new.segset));
	scoremask_2 = false(length(scr_new.modelset), length(scr_new.segset));
	[dummy,model_index_a,model_index_b] = intersect(scr_new.modelset,scr2.modelset);
	[dummy,seg_index_a,seg_index_b] = intersect(scr_new.segset,scr2.segset);
	scoremat_2(model_index_a,seg_index_a) = scr2.scoremat(model_index_b,seg_index_b);
	scoremask_2(model_index_a,seg_index_a) = scr2.scoremask(model_index_b,seg_index_b);

	% check for clashes
	assert(~any(scoremask_1(:)&scoremask_2(:)))
	
	% merge masks
	scoremat = scoremat_1 + scoremat_2;
	scoremask = scoremask_1 | scoremask_2;	
	
	% build new scr
	scr_new.scoremat = scoremat;
	scr_new.scoremask = scoremask;
	scr = scr_new;	
    end
end

assert(scr.validate())
