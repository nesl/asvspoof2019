function save_mat(scr,outfilename)
% Saves a Scores object to a mat file.
% Inputs:
%   scr: A Scores object.
%   outfilename: The name for the mat output file.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(outfilename,'char'))
assert(scr.validate())

warning('off','MATLAB:structOnObject')
scr = struct(scr);
warning('on','MATLAB:structOnObject')
save(outfilename,'scr');
