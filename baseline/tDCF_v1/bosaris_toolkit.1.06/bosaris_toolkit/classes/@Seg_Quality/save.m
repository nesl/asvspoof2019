function save(qual,outfilename)
% Saves a Seg_Quality object to a file.  The file type is
% determined by the extension.
% Inputs:
%   qual: The Seg_Quality object to be saved.
%   outfilename: The name for the output file.

assert(nargin==2)
assert(isa(qual,'Seg_Quality'))
assert(isa(outfilename,'char'))
assert(qual.validate())

dotpos = strfind(outfilename,'.');
assert(~isempty(dotpos))
extension = outfilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    qual.save_hdf5(outfilename);
elseif strcmp(extension,'mat')
    qual.save_mat(outfilename);
elseif strcmp(extension,'txt')
    qual.save_txt(outfilename);
else
    error('Unknown extension "%s"\n',extension)
end
