function ndx = read_mat(infilename)
% Reads a struct from a mat file and constructs an Ndx object.
% Inputs:
%   infilename: The name for the mat file to read.
% Outputs:
%   ndx: An Ndx object created from the information in the mat 
%     file.

assert(nargin==1)
assert(isa(infilename,'char'))

load(infilename,'ndx');
ndx = Ndx(ndx);

assert(ndx.validate())
