classdef Seg_Quality
% A class for storing segment quality measure information.  The
% class stores vectors of quality measures (in 'values') for each
% segment id (listed in 'ids').

properties
  ids
  values
end

methods
  % seg_qual = Seg_Quality()
  % seg_qual = Seg_Quality(seg_quality_struct)
  % seg_qual = Seg_Quality(ids,values)
  function qual = Seg_Quality(param1,param2)
  switch nargin
   case 0
    qual.ids = {};
    qual.values = [];
   case 1
    assert(isstruct(param1))
    assert(iscell(param1.ids))
    qual.ids = param1.ids;
    qual.values = param1.values;
   case 2    
    assert(iscell(param1))
    qual.ids = param1;
    qual.values = param2;
   otherwise
    error('Incorrect number of parameters in constructor.  Should be 0, 1, or 2.')     
  end
  end
end

methods
  save(qual,outfilename)
  save_hdf5(qual,outfilename)
  save_txt(qual,outfilename)
  save_mat(qual,outfilename)
  qual = align_with_ids(qual,ids)
  ok = validate(qual)
end

methods (Static)
  qual = read(infilename)
  qual = read_hdf5(infilename)
  qual = read_txt(infilename)  
  qual = read_mat(infilename)
  qual = merge(qual1,qual2) 
end

end
