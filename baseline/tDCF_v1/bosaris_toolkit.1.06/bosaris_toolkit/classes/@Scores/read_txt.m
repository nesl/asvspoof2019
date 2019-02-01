function scr = read_txt(infilename)
% Creates a Scores object from information stored in a text file.
% Inputs:
%   infilename: The name of the text file to read.
% Outputs:
%   scr: An object of type Scores constructed from the information in
%     the file.

assert(nargin==1)
assert(isa(infilename,'char'))

fid = fopen(infilename);

modelset = {};
segset = {};
chunk = 10000;
rd = chunk;
while rd==chunk
    lines = textscan(fid,'%s%s%*s',chunk);
    models = lines{1};
    testsegs = lines{2};
    modelset = union(modelset,models);
    segset = union(segset,testsegs);
    rd = length(models);
end

frewind(fid);
scoremask = false(length(modelset),length(segset));
scoremat = inf(size(scoremask));
rd = chunk;
while rd==chunk
    lines = textscan(fid,'%s%s%f',chunk);
    models = lines{1};
    testsegs = lines{2};
    scores = lines{3};
    
    [dummy,ii] = ismember(models,modelset); 
    [dummy,jj] = ismember(testsegs,segset);

    scoremask(sub2ind(size(scoremask),ii,jj)) = true;
    scoremat(sub2ind(size(scoremat),ii,jj)) = scores;
    
    rd = length(models);
end

fclose(fid);

scr = Scores();
scr.modelset = modelset;
scr.segset = segset;
scr.scoremat = scoremat;
scr.scoremask = scoremask;

assert(scr.validate())

end
