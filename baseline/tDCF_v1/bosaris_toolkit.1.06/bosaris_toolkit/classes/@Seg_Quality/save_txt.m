function save_txt(qual,outfilename)
% Saves a Seg_Quality object to a text file.
% Inputs:
%   qual: The Seg_Quality object to be saved.
%   outfilename: The name for the output text file.

assert(nargin==2)
assert(isa(qual,'Seg_Quality'))
assert(isa(outfilename,'char'))
assert(qual.validate())

outfile = fopen(outfilename,'w');

numids = length(qual.ids);
numvalues = size(qual.values,1);

fprintf(outfile,'%d\n',numvalues);

for ii=1:numids
    segname = qual.ids{ii};
    fprintf(outfile,'%s',segname);
    for jj=1:numvalues
        fprintf(outfile,' %f',qual.values(jj,ii));
    end
    fprintf(outfile,'\n');
end

fclose(outfile);
