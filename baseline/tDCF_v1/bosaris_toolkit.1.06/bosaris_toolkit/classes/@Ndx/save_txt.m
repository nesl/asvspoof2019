function save_txt(ndx,outfilename)
% Saves the Ndx to a text file.
% Inputs:
%   ndx: An object of type Ndx.
%   outfilename: The name for the output text file.

assert(nargin==2)
assert(isa(ndx,'Ndx'))
assert(isa(outfilename,'char'))
assert(ndx.validate())

outfile = fopen(outfilename,'w');

[x,y] = ind2sub(size(ndx.trialmask),find(ndx.trialmask));
numentries = length(x);
for ii=1:numentries
    modelname = ndx.modelset{x(ii)};
    segname = ndx.segset{y(ii)};
    fprintf(outfile,'%s %s\n',modelname,segname);
end

fclose(outfile);
