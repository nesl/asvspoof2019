function save_hdf5(key,outfilename)
% Saves the Key to an hdf5 file.
% Inputs:
%   key: An object of type Key.
%   outfilename: The name for the output hdf5 file.

assert(nargin==2)
assert(isa(key,'Key'))
assert(isa(outfilename,'char'))
assert(key.validate())

nummods = length(key.modelset);
numsegs = length(key.segset);

assert(size(key.tar,1)==nummods)
assert(size(key.tar,2)==numsegs)

assert(size(key.non,1)==nummods)
assert(size(key.non,2)==numsegs)

tar = int8(key.tar);
non = int8(key.non);

trialmask = tar - non;

hdf5write(outfilename,'/trial_mask',trialmask,'V71Dimensions',true);
hdf5write(outfilename,'/file_format','2.0','V71Dimensions',true,'WriteMode','append');
hdf5write(outfilename,'/ID/row_ids',key.modelset,'V71Dimensions',true,'WriteMode','append');
hdf5write(outfilename,'/ID/column_ids',key.segset,'V71Dimensions',true,'WriteMode','append');
