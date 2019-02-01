function qual = read_mat(infilename)
% Creates a Seg_Quality object from the information in a mat file.
% Inputs:
%   infilename: A mat file that contains a struct with the same
%     fields as the Seg_Quality class.
% Outputs:
%   qual: A Seg_Quality object encoding the quality measures in the
%     input mat file. 

assert(nargin==1)
assert(isa(infilename,'char'))

load(infilename,'qual');
qual = Seg_Quality(qual);

assert(qual.validate())
