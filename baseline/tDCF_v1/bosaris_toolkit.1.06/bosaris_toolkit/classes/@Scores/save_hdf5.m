function save_hdf5(scr,outfilename)
% Saves a Scores object to an hdf5 file.
% Inputs:
%   scr: A Scores object.
%   outfilename: The name for the hdf5 output file.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(outfilename,'char'))
assert(scr.validate())

scoremask = uint8(scr.scoremask);

hdf5write(outfilename,'/scores',scr.scoremat,'V71Dimensions',true);
hdf5write(outfilename,'/score_mask',scoremask,'V71Dimensions',true,'WriteMode','append');
hdf5write(outfilename,'/ID/row_ids',scr.modelset,'V71Dimensions',true,'WriteMode','append');
hdf5write(outfilename,'/ID/column_ids',scr.segset,'V71Dimensions',true,'WriteMode','append');
