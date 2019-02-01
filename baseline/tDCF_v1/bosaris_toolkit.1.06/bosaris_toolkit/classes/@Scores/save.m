function save(scr,outfilename)
% Saves a Scores object to a file.  The file type is determined by
% the extension.
% Inputs:
%   scr: The Scores object to be saved.
%   outfilename: The name for the output file.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(outfilename,'char'))
assert(scr.validate())

dotpos = strfind(outfilename,'.');
assert(~isempty(dotpos))
extension = outfilename(dotpos(end)+1:end);
assert(~isempty(extension))

if strcmp(extension,'hdf5') || strcmp(extension,'h5')
    scr.save_hdf5(outfilename);
elseif strcmp(extension,'mat')
    scr.save_mat(outfilename);
elseif strcmp(extension,'txt')
    scr.save_txt(outfilename);  
else
    error('Unknown extension "%s"\n',extension)
end
