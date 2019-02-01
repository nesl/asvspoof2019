function outkey = filter(inkey,modlist,seglist,keep)
% Removes some of the information in a key.  Useful for creating a
% gender specific key from a pooled gender key.  Depending on the
% value of 'keep', the two input lists indicate the strings to
% retain or the strings to discard.
% Inputs:
%   inkey: A Key object.
%   modlist: A cell array of strings which will be compared with
%     the modelset of 'inkey'.
%   seglist: A cell array of strings which will be compared with
%     the segset of 'inkey'.
%   keep: A boolean indicating whether modlist and seglist are the
%     models to keep or discard. 
% Outputs:
%   outkey: A filtered version of 'inkey'.

if nargin == 0
    test_this();
    return
else
    assert(nargin==4)
end

assert(isa(inkey,'Key'))
assert(iscell(modlist))
assert(iscell(seglist))
assert(inkey.validate())

if keep
    keepmods = modlist;
    keepsegs = seglist;
else
    keepmods = setdiff(inkey.modelset,modlist);
    keepsegs = setdiff(inkey.segset,seglist);
end

keepmodidx = ismember(inkey.modelset,keepmods);
keepsegidx = ismember(inkey.segset,keepsegs);

outkey = Key();
outkey.modelset = inkey.modelset(keepmodidx);
outkey.segset = inkey.segset(keepsegidx);
outkey.tar = inkey.tar(keepmodidx,keepsegidx);
outkey.non = inkey.non(keepmodidx,keepsegidx);

assert(outkey.validate())

if length(inkey.modelset) > length(outkey.modelset)
    log_info('Number of models reduced from %d to %d.\n',length(inkey.modelset),length(outkey.modelset));
end
if length(inkey.segset) > length(outkey.segset)
    log_info('Number of test segments reduced from %d to %d.\n',length(inkey.segset),length(outkey.segset));
end

end

function test_this()

key = Key();
key.modelset = {'aaa','bbb','ccc','ddd'};
key.segset = {'11','22','33','44','55'};
key.tar = logical([1,0,0,1,0;0,1,0,1,1;0,0,0,1,0;1,1,0,0,0]);
key.non = logical([0,1,0,0,0;1,0,0,0,0;1,1,1,0,0;0,0,1,1,1]);

fprintf('key.modelset\n');
disp(key.modelset)
fprintf('key.segset\n');
disp(key.segset)
fprintf('key.tar\n');
disp(key.tar)
fprintf('key.non\n');
disp(key.non)

modlist = {'bbb','ddd'}
seglist = {'11','55'}

keep = true

out = Key.filter(key,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.tar\n');
disp(out.tar)
fprintf('out.non\n');
disp(out.non)

keep = false

out = Key.filter(key,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.tar\n');
disp(out.tar)
fprintf('out.non\n');
disp(out.non)


modlist = {'bbb','ddd','eee'}
seglist = {'11','66','77','55'}

keep = true

out = Key.filter(key,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.tar\n');
disp(out.tar)
fprintf('out.non\n');
disp(out.non)

keep = false

out = Key.filter(key,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.tar\n');
disp(out.tar)
fprintf('out.non\n');
disp(out.non)

end
