function ndx = read(infilename)
% Reads information from a file and constructs an Ndx object.  The
% type of file is deduced from the extension.
% Inputs:
%   infilename: The name for the file to read.  The extension
%     (part after the final '.') must be a known type.
% Outputs:
%   ndx: An Ndx object created from the information in the file.

assert(nargin==1)
assert(isa(infilename,'char'))

dotpos = strfind(infilename,'.');
assert(~isempty(dotpos))
extension = infilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    ndx = Ndx.read_hdf5(infilename);
elseif strcmp(extension,'mat')
    ndx = Ndx.read_mat(infilename);
elseif strcmp(extension,'txt')
    ndx = Ndx.read_txt(infilename);
else
    error('Unknown extension "%s"\n',extension)
end
