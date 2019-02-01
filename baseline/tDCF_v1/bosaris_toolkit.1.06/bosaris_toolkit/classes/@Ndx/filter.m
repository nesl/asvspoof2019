function outndx = filter(inndx,modlist,seglist,keep)
% Removes some of the information in an Ndx.  Useful for creating a
% gender specific Ndx from a pooled gender Ndx.  Depending on the
% value of 'keep', the two input lists indicate the strings to
% retain or the strings to discard.
% Inputs:
%   inndx: An Ndx object.
%   modlist: A cell array of strings which will be compared with
%     the modelset of 'inndx'.
%   seglist: A cell array of strings which will be compared with
%     the segset of 'inndx'.
%   keep: A boolean indicating whether modlist and seglist are the
%     models to keep or discard. 
% Outputs:
%   outndx: A filtered version of 'inndx'.

if nargin == 0
    test_this();
    return
end

assert(nargin==4)
assert(isa(inndx,'Ndx'))
assert(inndx.validate())
assert(iscell(modlist))
assert(iscell(seglist))

if keep
    keepmods = modlist;
    keepsegs = seglist;
else
    keepmods = setdiff(inndx.modelset,modlist);
    keepsegs = setdiff(inndx.segset,seglist);
end

keepmodidx = ismember(inndx.modelset,keepmods);
keepsegidx = ismember(inndx.segset,keepsegs);

outndx = Ndx();
outndx.modelset = inndx.modelset(keepmodidx);
outndx.segset = inndx.segset(keepsegidx);
outndx.trialmask = inndx.trialmask(keepmodidx,keepsegidx);

assert(outndx.validate())

if length(inndx.modelset) > length(outndx.modelset)
    log_info('Number of models reduced from %d to %d.\n',length(inndx.modelset),length(outndx.modelset));
end
if length(inndx.segset) > length(outndx.segset)
    log_info('Number of test segments reduced from %d to %d.\n',length(inndx.segset),length(outndx.segset));
end

end

function test_this()

ndx = Ndx();
ndx.modelset = {'aaa','bbb','ccc','ddd'};
ndx.segset = {'11','22','33','44','55'};
ndx.trialmask = true(4,5);

fprintf('ndx.modelset\n');
disp(ndx.modelset)
fprintf('ndx.segset\n');
disp(ndx.segset)
fprintf('ndx.trialmask\n');
disp(ndx.trialmask)

modlist = {'bbb','ddd'}
seglist = {'11','55'}

keep = true

out = Ndx.filter(ndx,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.trialmask\n');
disp(out.trialmask)

keep = false

out = Ndx.filter(ndx,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.trialmask\n');
disp(out.trialmask)


modlist = {'bbb','ddd','eee'}
seglist = {'11','66','77','55'}

keep = true

out = Ndx.filter(ndx,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.trialmask\n');
disp(out.trialmask)

keep = false

out = Ndx.filter(ndx,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.trialmask\n');
disp(out.trialmask)

end
