function save_hdf5(qual,outfilename)
% Saves a Seg_Quality object to an hdf5 file.
% Inputs:
%   qual: The Seg_Quality object to be saved.
%   outfilename: The name for the hdf5 output file.

assert(nargin==2)
assert(isa(qual,'Seg_Quality'))
assert(isa(outfilename,'char'))
assert(qual.validate())

ids = cellstr(qual.ids);

hdf5write(outfilename,'/values',qual.values,'V71Dimensions',true);
hdf5write(outfilename,'/ids',ids,'V71Dimensions',true,'WriteMode','append');
