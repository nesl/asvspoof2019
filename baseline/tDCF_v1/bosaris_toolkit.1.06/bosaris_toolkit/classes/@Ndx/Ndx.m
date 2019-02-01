classdef Ndx
% A class that encodes trial index information.  It has a list of
% model names and a list of test segment names and a matrix
% indicating which combinations of model and test segment are
% trials of interest.

properties
  modelset
  segset
  trialmask
end

methods
  % ndx = Ndx()
  % ndx = Ndx(ndx_struct)
  % ndx = Ndx(model_list,seg_list)
  % ndx = Ndx(model_list,seg_list,trial_mask)
  function ndx = Ndx(param1,param2,param3)
  switch nargin
   case 0
    ndx.modelset = {};
    ndx.segset = {}; 
    ndx.trialmask = logical([]);
   case 1
    assert(isstruct(param1))
    assert(iscell(param1.modelset))
    assert(iscell(param1.segset))
    ndx.modelset = param1.modelset;
    ndx.segset = param1.segset;
    ndx.trialmask = param1.trialmask;
   case 2
    assert(iscell(param1))
    assert(iscell(param2))
    ndx.modelset = param1;
    ndx.segset = param2;
    ndx.trialmask = true(length(param1),length(param2));
   case 3
    assert(iscell(param1))
    assert(iscell(param2))
    ndx.modelset = param1;
    ndx.segset = param2;
    ndx.trialmask = param3;
   otherwise
    error('Incorrect number of parameters in constructor.  Should be 0, 1, 2 or 3.')
  end 
  end
end

methods
  save(ndx,outfilename)
  save_hdf5(ndx,outfilename)
  save_mat(ndx,outfilename)
  save_txt(ndx,outfilename)
  outndx = filter(inndx,modlist,seglist,keep)
  ok = validate(ndx)
end

methods (Static = true)
  ndx = read(infilename)
  ndx = read_hdf5(infilename)
  ndx = read_mat(infilename)
  ndx = read_txt(infilename)
%  ndx = merge(ndx1,ndx2)
%  ndx = merge(ndx_obj_array)
  ndx = merge(param1,param2)
end

end
