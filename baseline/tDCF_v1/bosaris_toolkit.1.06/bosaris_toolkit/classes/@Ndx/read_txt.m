function ndx = read_txt(infilename)
% Creates an Ndx object from information stored in a text file.
% Inputs:
%   infilename: The name of the text file to read.
% Outputs:
%   ndx: An object of type Ndx constructed from the information in
%     the file.

assert(nargin==1)
assert(isa(infilename,'char'))

fid = fopen(infilename);
lines = textscan(fid,'%s%s');
fclose(fid);

models = lines{1};
testsegs = lines{2};
modelset = {};
segset = {};
modelset = union(modelset,models);
segset = union(segset,testsegs);

trialmask = false(length(modelset),length(segset));
[dummy,ii] = ismember(models,modelset); 
[dummy,jj] = ismember(testsegs,segset);
trialmask(sub2ind(size(trialmask),ii,jj)) = true;

ndx = Ndx();
ndx.modelset = modelset;
ndx.segset = segset;
ndx.trialmask = trialmask;
assert(ndx.validate())

end
