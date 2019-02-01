function key = read_txt(infilename)
% Creates a Key object from information stored in a text file.
% Inputs:
%   infilename: The name of the text file to read.
% Outputs:
%   key: An object of type Key constructed from the information in
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
tar = false(length(modelset),length(segset));
non = tar;
rd = chunk;
while rd==chunk
    lines = textscan(fid,'%s%s%s',chunk);
    models = lines{1};
    testsegs = lines{2};
    is_tar = logical(strcmpi(lines{3},'target'));
    
    [dummy,ii] = ismember(models,modelset); 
    [dummy,jj] = ismember(testsegs,segset);

    tar(sub2ind(size(tar),ii,jj)) = is_tar;
    non(sub2ind(size(non),ii,jj)) = ~is_tar;
    
    rd = length(models);
end
fclose(fid);

key = Key();
key.modelset = modelset;
key.segset = segset;
key.tar = tar;
key.non = non;

assert(key.validate())

end
