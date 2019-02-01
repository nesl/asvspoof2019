function scr = read(infilename)
% Reads information from a file and constructs a Scores object.  The
% type of file is deduced from the extension.
% Inputs:
%   infilename: The name for the file to read.  The extension
%     (part after the final '.') must be a known type.
% Outputs:
%   scr: A Scores object created from the information in the file.

assert(nargin==1)
assert(isa(infilename,'char'))

dotpos = strfind(infilename,'.');
assert(~isempty(dotpos))
extension = infilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    scr = Scores.read_hdf5(infilename);
elseif strcmp(extension,'mat')
    scr = Scores.read_mat(infilename);
elseif strcmp(extension,'txt')
    scr = Scores.read_txt(infilename);
else
    error('Unknown extension "%s"\n',extension)
end
