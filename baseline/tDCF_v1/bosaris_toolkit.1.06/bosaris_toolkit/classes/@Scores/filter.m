function outscr = filter(inscr,modlist,seglist,keep)
% Removes some of the information in a Scores object.  Useful for
% creating a gender specific score set from a pooled gender score
% set.  Depending on the value of 'keep', the two input lists
% indicate the models and test segments (and their associated
% scores) to retain or discard. 
% Inputs:
%   inscr: A Scores object.
%   modlist: A cell array of strings which will be compared with
%     the modelset of 'inscr'.
%   seglist: A cell array of strings which will be compared with
%     the segset of 'inscr'.
%   keep: A boolean indicating whether modlist and seglist are the
%     models to keep or discard. 
% Outputs:
%   outscr: A filtered version of 'inscr'.

if nargin == 0
    test_this();
    return
end

assert(nargin==4)
assert(isa(inscr,'Scores'))
assert(iscell(modlist))
assert(iscell(seglist))
assert(inscr.validate())

if keep
    keepmods = modlist;
    keepsegs = seglist;
else
    keepmods = setdiff(inscr.modelset,modlist);
    keepsegs = setdiff(inscr.segset,seglist);
end

keepmodidx = ismember(inscr.modelset,keepmods);
keepsegidx = ismember(inscr.segset,keepsegs);

outscr = Scores();
outscr.modelset = inscr.modelset(keepmodidx);
outscr.segset = inscr.segset(keepsegidx);
outscr.scoremat = inscr.scoremat(keepmodidx,keepsegidx);
outscr.scoremask = inscr.scoremask(keepmodidx,keepsegidx);

assert(outscr.validate())

if length(inscr.modelset) > length(outscr.modelset)
    log_info('Number of models reduced from %d to %d.\n',length(inscr.modelset),length(outscr.modelset));
end
if length(inscr.segset) > length(outscr.segset)
    log_info('Number of test segments reduced from %d to %d.\n',length(inscr.segset),length(outscr.segset));
end

end

function test_this()

scr = Scores();
scr.modelset = {'aaa','bbb','ccc','ddd'};
scr.segset = {'11','22','33','44','55'};
scr.scoremat = [1,2,3,4,5;6,7,8,9,10;11,12,13,14,15;16,17,18,19,20];
scr.scoremask = true(4,5);

fprintf('scr.modelset\n');
disp(scr.modelset)
fprintf('scr.segset\n');
disp(scr.segset)
fprintf('scr.scoremat\n');
disp(scr.scoremat)

modlist = {'bbb','ddd'}
seglist = {'11','55'}

keep = true

out = Scores.filter(scr,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.scoremat\n');
disp(out.scoremat)
fprintf('out.scoremask\n');
disp(out.scoremask)

keep = false

out = Scores.filter(scr,modlist,seglist,keep);

fprintf('out.modelset\n');
disp(out.modelset)
fprintf('out.segset\n');
disp(out.segset)
fprintf('out.scoremat\n');
disp(out.scoremat)
fprintf('out.scoremask\n');
disp(out.scoremask)

end
