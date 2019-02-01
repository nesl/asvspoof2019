function save_mat(ndx,outfilename)
% Saves the Ndx object in a mat file.
% Inputs:
%   ndx: The Ndx object to save.
%   outfilename: The name of the output mat file.

assert(nargin==2)
assert(isa(ndx,'Ndx'))
assert(isa(outfilename,'char'))
assert(ndx.validate())

warning('off','MATLAB:structOnObject')
ndx = struct(ndx);
warning('on','MATLAB:structOnObject')
save(outfilename,'ndx');
