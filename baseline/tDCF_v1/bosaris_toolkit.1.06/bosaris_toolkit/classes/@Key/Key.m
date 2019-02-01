classdef Key
% A class for representing a Key i.e. it classifies trials as
% target or non-target trials.

properties
  modelset
  segset
  tar
  non
end

methods
  % key = Key()
  % key = Key(key_struct)
  % key = Key(model_list,seg_list,target_mask,nontarget_mask)
  function key = Key(param1,param2,param3,param4)
  switch nargin
   case 0
    key.modelset = {};
    key.segset = {}; 
    key.tar = logical([]);
    key.non = logical([]);
   case 1
    assert(isstruct(param1))
    assert(iscell(param1.modelset))
    assert(iscell(param1.segset))
    key.modelset = param1.modelset;
    key.segset = param1.segset;
    key.tar = param1.tar;
    key.non = param1.non;
   case 4
    assert(iscell(param1))
    assert(iscell(param2))
    key.modelset = param1;
    key.segset = param2;
    key.tar = param3;
    key.non = param4;
   otherwise
    error('Incorrect number of parameters in constructor.  Should be 0, 1, or 4.')
  end
  end
end

methods
  save(key,outfilename)
  save_hdf5(key,outfilename)
  save_mat(key,outfilename)
  save_txt(key,outfilename)
  outkey = filter(inkey,modlist,seglist,keep)
  ndx = to_ndx(key)
  ok = validate(key)
end

methods (Static = true)
  key = read(infilename)
  key = read_hdf5(infilename)
  key = read_mat(infilename)
  key = read_txt(infilename)
%  key = merge(key1,key2)
%  key = merge(key_obj_array)
  key = merge(param1,param2)
end

end
