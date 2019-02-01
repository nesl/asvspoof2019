function save_hdf5(ndx,outfilename)
% Saves the Ndx object in an hdf5 file.
% Inputs:
%   ndx: The Ndx object to save.
%   outfilename: The name of the output hdf5 file.

assert(nargin==2)
assert(isa(ndx,'Ndx'))
assert(isa(outfilename,'char'))
assert(ndx.validate())

nummods = length(ndx.modelset);
numsegs = length(ndx.segset);

assert(size(ndx.trialmask,1)==nummods)
assert(size(ndx.trialmask,2)==numsegs)

trialmask = uint8(ndx.trialmask);

hdf5write(outfilename,'/trial_mask',trialmask,'V71Dimensions',true);
hdf5write(outfilename,'/ID/row_ids',ndx.modelset,'V71Dimensions',true,'WriteMode','append');
hdf5write(outfilename,'/ID/column_ids',ndx.segset,'V71Dimensions',true,'WriteMode','append');
