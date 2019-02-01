function scr = read_mat(infilename)
% Creates a Scores object from the information in a mat file.
% Inputs:
%   infilename: A mat file containing scores.
% Outputs:
%   scr: A Scores object encoding the scores in the input mat 
%     file. 

assert(nargin==1)
assert(isa(infilename,'char'))

load(infilename,'scr');
scr = Scores(scr);

assert(scr.validate())
