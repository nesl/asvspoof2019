function key = read(infilename)
% Reads information from a file and constructs a Key object.  The
% type of file is deduced from the extension.
% Inputs:
%   infilename: The name for the file to read.  The extension
%     (part after the final '.') must be a known type.
% Outputs:
%   key: A Key object created from the information in the file.

assert(nargin==1)
assert(isa(infilename,'char'))

dotpos = strfind(infilename,'.');
assert(~isempty(dotpos))
extension = infilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    key = Key.read_hdf5(infilename);
elseif strcmp(extension,'mat')
    key = Key.read_mat(infilename);
elseif strcmp(extension,'txt')
    key = Key.read_txt(infilename);
else
    error('Unknown extension "%s"\n',extension)
end
