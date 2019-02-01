function scr = read_hdf5(infilename)
% Creates a Scores object from the information in an hdf5 file.
% Inputs:
%   infilename: An hdf5 file containing scores.
% Outputs:
%   scr: A Scores object encoding the scores in the input hdf5
%     file. 

assert(nargin==1)
assert(isa(infilename,'char'))

scr = Scores();

scr.scoremat = hdf5read(infilename,'/scores','V71Dimensions',true);
scr.scoremask = logical(hdf5read(infilename,'/score_mask','V71Dimensions',true));

tmp = hdf5read(infilename,'/ID/row_ids','V71Dimensions',true);
numentries = length(tmp);
scr.modelset = cell(numentries,1);
for ii=1:numentries
    scr.modelset{ii} = tmp(ii).Data;
end

tmp = hdf5read(infilename,'/ID/column_ids','V71Dimensions',true);
numentries = length(tmp);
scr.segset = cell(numentries,1);
for ii=1:numentries
    scr.segset{ii} = tmp(ii).Data;
end

assert(scr.validate())
