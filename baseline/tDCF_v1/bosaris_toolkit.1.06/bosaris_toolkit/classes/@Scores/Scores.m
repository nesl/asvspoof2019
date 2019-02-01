classdef Scores
% A class for storing scores for trials.  The modelset and segset
% fields are lists of model and test segment names respectively.
% The element i,j of scoremat and scoremask corresponds to the
% trial involving model i and test segment j.  scoremat contains
% the scores for the trials and scoremask is a matrix of booleans
% which indicates the trials of interest i.e. the entry i,j in
% scoremat should be ignored if scoremask(i,j) is false.

properties
  scoremat
  scoremask
  modelset
  segset
end

methods
  % scr = Scores()
  % scr = Scores(score_struct)
  % scr = Scores(score_matrix,model_list,seg_list)
  % scr = Scores(score_matrix,model_list,seg_list,score_mask)  
  function scr = Scores(param1,param2,param3,param4)
    switch nargin
     case 0
      scr.scoremat = [];
      scr.scoremask = logical([]);
      scr.modelset = {};
      scr.segset = {}; 
     case 1
      assert(isstruct(param1))
      assert(iscell(param1.modelset))
      assert(iscell(param1.segset))
      scr.modelset = param1.modelset;
      scr.segset = param1.segset;
      scr.scoremat = param1.scoremat;
      scr.scoremask = param1.scoremask;
     case 3
      assert(iscell(param2))
      assert(iscell(param3))
      scr.modelset = param2;
      scr.segset = param3;
      scr.scoremat =  param1;
      scr.scoremask = true(size(param1));
     case 4
      assert(iscell(param2))
      assert(iscell(param3))
      scr.modelset = param2;
      scr.segset = param3;
      scr.scoremat =  param1;
      scr.scoremask = param4;
     otherwise
      error('Incorrect number of parameters in constructor.  Should be 0, 1, 3 or 4.')
    end
  end
end

methods
  save(scr,outfilename)
  save_hdf5(scr,outfilename)
  save_mat(scr,outfilename)
  save_txt(scr,outfilename)
  [tar,non] = get_tar_non(scr,key)
  aligned_scr = align_with_ndx(scr,ndx)
  new_scr = set_missing_to_value(scr,ndx,value)
  new_scr = transform(scr,func)
  outscr = filter(inscr,modlist,seglist,keep)
  ok = validate(scr)
end

methods (Static = true)
  scr = read(infilename)
  scr = read_hdf5(infilename)
  scr = read_mat(infilename)
  scr = read_txt(infilename)
%  scr = merge(scr1,scr2)
%  scr = merge(scr_obj_array)
  scr = merge(param1,param2)  
end

end
