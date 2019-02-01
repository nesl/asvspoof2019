function save_mat(key,outfilename)
% Saves the Key to a mat file.
% Inputs:
%   key: An object of type Key.
%   outfilename: The name for the output mat file.

assert(nargin==2)
assert(isa(key,'Key'))
assert(isa(outfilename,'char'))
assert(key.validate())

warning('off','MATLAB:structOnObject')
key = struct(key);
warning('on','MATLAB:structOnObject')
save(outfilename,'key');
