function idmap = read_txt(infilename)
% Reads ids from a text file and constructs an Id_Map object.
% Inputs:
%   infilename: The name for the text file to read.
% Outputs:
%   idmap: An Id_Map object created from the information in the text
%     file.

assert(nargin==1)
assert(isa(infilename,'char'))

fid = fopen(infilename);
lines = textscan(fid,'%s%s');
fclose(fid);

idmap = Id_Map();
idmap.leftids = lines{1};
idmap.rightids = lines{2};

assert(idmap.validate())

end
