function qual = read_hdf5(infilename)
% Creates a Seg_Quality object from the contents of an hdf5 file.  
% Inputs:
%   infilename: The name of the hdf5 file containing the quality
%     measure data.
% Outputs:
%   qual: A Seg_Quality object encoding the information in the input
%     hdf5 file.

assert(nargin==1)
assert(isa(infilename,'char'))

qual = Seg_Quality();

qual.values = hdf5read(infilename,'/values','V71Dimensions',true);

tmp = hdf5read(infilename,'/ids','V71Dimensions',true);
numentries = length(tmp);
qual.ids = cell(numentries,1);
for ii=1:numentries
    qual.ids{ii} = tmp(ii).Data;
end

assert(qual.validate())
