function rightidlist = map_left_to_right(idmap,leftidlist)
% Maps a list of ids to a new list of ids using the given map.  The
% input ids are matched against the leftids of the map and the
% output ids are taken from the corresponding rightids of the map.
% Inputs:
%   idmap: The Id_Map giving the mapping between the input and
%     output string lists.
%   leftidlist: A list of strings to be matched against the
%     leftids of the idmap.  The rightids corresponding to these
%     leftids will be returned.
% Outputs:
%   rightidlist: A list of strings that are the mappings of the
%     strings in leftidlist. 

assert(nargin==2)
assert(isa(idmap,'Id_Map'))
assert(iscell(leftidlist))
assert(idmap.validate())

tmpmap.keySet = idmap.leftids;
tmpmap.values = idmap.rightids;

[rightidlist,is_present] = maplookup(tmpmap,leftidlist);
num_dropped = length(is_present) - sum(is_present);
if num_dropped ~= 0
    log_warning('%d ids could not be mapped because they were not present in the map.\n',num_dropped);
end

end
