function key = read_mat(infilename)
% Reads a struct from a mat file and constructs a Key object.
% Inputs:
%   infilename: The name for the mat file to read.
% Outputs:
%   key: A Key object created from the information in the mat 
%     file.

assert(nargin==1)
assert(isa(infilename,'char'))

load(infilename,'key');
key = Key(key);

assert(key.validate())
