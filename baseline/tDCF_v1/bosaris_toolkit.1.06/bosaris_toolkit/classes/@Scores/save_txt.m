function save_txt(scr,outfilename)
% Saves a Scores object to a text file.
% Inputs:
%   scr: A Scores object.
%   outfilename: The name for the text output file.

assert(nargin==2)
assert(isa(scr,'Scores'))
assert(isa(outfilename,'char'))
assert(scr.validate())

[x,y] = ind2sub(size(scr.scoremask),find(scr.scoremask));
numscores = length(x);

outfile = fopen(outfilename,'w');

for ii=1:numscores
    modelname = scr.modelset{x(ii)};
    segname = scr.segset{y(ii)};
    score = scr.scoremat(x(ii),y(ii));
    assert(isfinite(score))
    fprintf(outfile,'%s %s %f\n',modelname,segname,score);
end

fclose(outfile);
