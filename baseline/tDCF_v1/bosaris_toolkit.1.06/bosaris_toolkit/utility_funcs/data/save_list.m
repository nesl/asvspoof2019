function save_list(filename,mylist)
% Saves a cell array of strings to a text file.
% Inputs:
%   filename: A text file containing a single column of strings.
%   outlist: A cell array of strings.

assert(isa(filename,'char'))
assert(iscell(mylist))

fid = fopen(filename,'w');

for ii=1:length(mylist)
    fprintf(fid,'%s\n',mylist{ii});
end

fclose(fid);
