function key = read_hdf5(infilename)
% Reads a Key object from an hdf5 file.
% Inputs:
%   infilename: The name for the hdf5 file to read.
% Outputs:
%   key: A Key object created from the information in the hdf5
%     file.

assert(nargin==1)
assert(isa(infilename,'char'))

key = Key();

key.modelset = h5strings_to_cell(infilename,'/ID/row_ids');
key.segset = h5strings_to_cell(infilename,'/ID/column_ids');

oldformat = false;
info = hdf5info(infilename);
datasets = info.GroupHierarchy.Datasets;
for ii=1:length(datasets)
    if strcmp(datasets(ii).Name,'/target_mask')
	oldformat = true;
    end
end

if oldformat
    key.tar = logical(hdf5read(infilename,'/target_mask','V71Dimensions',true));
    key.non = logical(hdf5read(infilename,'/nontarget_mask','V71Dimensions',true));
else
    trialmask = hdf5read(infilename,'/trial_mask','V71Dimensions',true);
    key.tar = trialmask > 0.5;
    key.non = trialmask < -0.5;
end

assert(key.validate())

function cellstrarr = h5strings_to_cell(infilename,attribname)
tmp = hdf5read(infilename,attribname,'V71Dimensions',true);
numentries = length(tmp);
cellstrarr = cell(numentries,1);
for ii=1:numentries
    cellstrarr{ii} = tmp(ii).Data;
end
