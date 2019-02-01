function ndx = read_hdf5(infilename)
% Creates an Ndx object from the information in an hdf5 file.
% Inputs:
%   infilename: The name of the hdf5 file contain the information
%     necessary to construct an Ndx object.
% Outputs:
%   ndx: An Ndx object containing the information in the input
%     file.

assert(nargin==1)
assert(isa(infilename,'char'))

ndx = Ndx();
ndx.modelset = h5strings_to_cell(infilename,'/ID/row_ids');
ndx.segset = h5strings_to_cell(infilename,'/ID/column_ids');
ndx.trialmask = logical(hdf5read(infilename,'/trial_mask','V71Dimensions',true));

assert(ndx.validate())

function cellstrarr = h5strings_to_cell(infilename,attribname)
tmp = hdf5read(infilename,attribname,'V71Dimensions',true);
numentries = length(tmp);
cellstrarr = cell(numentries,1);
for ii=1:numentries
    cellstrarr{ii} = tmp(ii).Data;
end
