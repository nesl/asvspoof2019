function outmap = read_map(filename)
% Reads a map from a file.  The file must contain two columns with
% keys in the first column and values in the second column.
% Inputs:
%   filename: The name of the text file containing the map.
% Outputs:
%   outmap: A struct with a cell array of keys and a cell array of
%   values.  The cell arrays will be the same length and will
%   contain strings.  

assert(isa(filename,'char'))

fid = fopen(filename,'r');
cc = textscan(fid,'%s%s');
fclose(fid);

outmap.keySet = cc{1};
outmap.values = cc{2};
