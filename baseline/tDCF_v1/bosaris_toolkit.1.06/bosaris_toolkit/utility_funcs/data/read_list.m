function outlist = read_list(filename)
% Reads a list from a file.
% Inputs:
%   filename: A text file containing a single column of strings.
% Outputs:
%   outlist: A cell array of strings --- one string for each line
%     in the file. 

assert(isa(filename,'char'))

fid = fopen(filename,'r');
cc = textscan(fid,'%s');
fclose(fid);

outlist = cc{1};
