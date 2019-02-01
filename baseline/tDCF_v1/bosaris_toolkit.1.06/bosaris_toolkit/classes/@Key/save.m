function save(key,outfilename)
% Saves a Key object to a file.  The file type is determined by
% the extension.
% Inputs:
%   key: The Key object to be saved.
%   outfilename: The name for the output file.

assert(nargin==2)
assert(isa(key,'Key'))
assert(isa(outfilename,'char'))
assert(key.validate())

dotpos = strfind(outfilename,'.');
assert(~isempty(dotpos))
extension = outfilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    key.save_hdf5(outfilename);
elseif strcmp(extension,'mat')
    key.save_mat(outfilename);
elseif strcmp(extension,'txt')
    key.save_txt(outfilename);  
else
    error('Unknown extension "%s"\n',extension)
end
