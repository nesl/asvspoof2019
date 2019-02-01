function save(ndx,outfilename)
% Saves an Ndx object to a file.  The file type is determined by
% the extension.
% Inputs:
%   ndx: The Ndx object to be saved.
%   outfilename: The name for the output file.

assert(nargin==2)
assert(isa(ndx,'Ndx'))
assert(isa(outfilename,'char'))
assert(ndx.validate())

dotpos = strfind(outfilename,'.');
assert(~isempty(dotpos))
extension = outfilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    ndx.save_hdf5(outfilename);
elseif strcmp(extension,'mat')
    ndx.save_mat(outfilename);
elseif strcmp(extension,'txt')
    ndx.save_txt(outfilename);  
else
    error('Unknown extension "%s"\n',extension)
end
