function ndx = map_mod_names(ndx,src_map,dst_map)
% Changes the model names in an index using two maps.  The one map
% lists the training segment for each model name and the other map
% lists the new model name for each training segment.  Existing
% model names are replaced by new model names that are mapped to
% the same training segment.  If a model name is not present in the
% src_map, it is left unchanged in the output ndx.  If a train seg
% is not present in the dst_map, the source model is dropped from
% the output ndx (along with all its trials).
% Inputs:
%   ndx: the Key or Ndx for which the model names must be changed
%   scr_map: the map from current model names to trn seg names
%   dst_map: the map from trn seg names to new model names
% Outputs:
%   ndx: the Key or Ndx with a modified modelset field

if nargin == 0
    test_this()
    return
end

assert(nargin==3)
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))
assert(isstruct(src_map))
assert(isstruct(dst_map))
assert(isfield(src_map,'keySet'))
assert(isfield(dst_map,'keySet'))
assert(isfield(src_map,'values'))
assert(isfield(dst_map,'values'))

[trnsegs,is_present1] = maplookup(src_map,ndx.modelset);
num_unchanged = length(is_present1) - sum(is_present1);
if num_unchanged ~= 0
    log_warning('Keeping %d model name(s) unchanged.\n',num_unchanged);
end

[newnames,is_present2] = maplookup(dst_map,trnsegs);
num_dropped = length(is_present2) - sum(is_present2);
if num_dropped ~= 0
    log_warning('Discarding %d row(s) in score matrix.\n',num_dropped);
end

keepndxs = true(length(ndx.modelset),1);
keepndxs(is_present1) = is_present2;
newmodnames = cell(length(is_present2),1);
newmodnames(is_present2) = newnames;
ndx.modelset(is_present1) = newmodnames;

ndx.modelset = ndx.modelset(keepndxs);
if isa(ndx,'Ndx')
    ndx.trialmask = ndx.trialmask(keepndxs,:);
else
    ndx.tar = ndx.tar(keepndxs,:);
    ndx.non = ndx.non(keepndxs,:);
end

function test_this()

src_map.keySet = {'mod1','mod2','mod3','mod4','mod8'};
src_map.values = {'seg1','seg2','seg3','seg5','seg8'};
dst_map.keySet = {'seg1','seg2','seg3','seg4','seg5','seg6'};
dst_map.values = {'new1','new2','new3','new4','new5','new6'};
ndx = Ndx();

fprintf('Test1\n');
ndx.modelset = {'mod2','mod3','mod4'};
ndx.trialmask = true(3,4);
fprintf('Input:\n');
disp(ndx.modelset)
fprintf('Output should be:\n');
out = {'new2','new3','new5'};
disp(out)
fprintf('Output is:\n');
newndx = map_mod_names(ndx,src_map,dst_map);
disp(newndx.modelset)

fprintf('Test2\n');
ndx.modelset = {'mod2','mod3','mod10','mod4','mod6'};
ndx.trialmask = true(5,4);
fprintf('Input:\n');
disp(ndx.modelset)
fprintf('Output should be:\n');
out = {'new2','new3','mod10','new5','mod6'};
disp(out)
fprintf('Output is:\n');
newndx = map_mod_names(ndx,src_map,dst_map);
disp(newndx.modelset)

fprintf('Test3\n');
ndx.modelset = {'mod2','mod3','mod10','mod4','mod8','mod6'};
ndx.trialmask = true(6,4);
fprintf('Input:\n');
disp(ndx.modelset)
fprintf('Output should be:\n');
out = {'new2','new3','mod10','new5','mod6'};
disp(out)
fprintf('Output is:\n');
newndx = map_mod_names(ndx,src_map,dst_map);
disp(newndx.modelset)
