function save_txt(key,outfilename)
% Saves the Key to a text file.
% Inputs:
%   key: An object of type Key.
%   outfilename: The name for the output text file.

assert(nargin==2)
assert(isa(key,'Key'))
assert(isa(outfilename,'char'))
assert(key.validate())

outfile = fopen(outfilename,'w');

[x,y] = ind2sub(size(key.tar),find(key.tar));
numentries = length(x);
for ii=1:numentries
    modelname = key.modelset{x(ii)};
    segname = key.segset{y(ii)};
    fprintf(outfile,'%s %s target\n',modelname,segname);
end

[x,y] = ind2sub(size(key.non),find(key.non));
numentries = length(x);
for ii=1:numentries
    modelname = key.modelset{x(ii)};
    segname = key.segset{y(ii)};
    fprintf(outfile,'%s %s nontarget\n',modelname,segname);
end

fclose(outfile);
