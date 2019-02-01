function [values,is_present] = maplookup(map,keys)
% Does a map lookup, to map mutliple keys to multiple values in one call.
% The parameter 'map' represents a function, where each key maps to a
% unique value. Each value may be mapped to by one or more keys.
%
% Inputs:
%   map.keySet: a one-dimensional cell array; 
%               or one-dimensional numeric array;
%               or a two dimensional char array, where each row is an 
%               element.
%               The elements should be unique. If there are repeated elements, 
%               the last one of each will be used.
%
%   map.values: The values that each member of keySet maps to, in the same
%               order.
%
%   keys: The array of keys to look up in the map. The class should agree
%         with map.keySet.
%
%  Outputs:
%    values: a one-dimensional cell array; or one dimensional numeric array;
%            or a two dimensional char array, where rows are string values.
%            Each value corresponds to one of the elements in keys.
%         
%    is_present: logical array of same size as keys, indicating which keys
%                are in map.keySet.
%                Optional: if not asked, then maplookup crashes if one or
%                more keys are not in the map. If is_present is asked,
%                then maplookup does not crash for missing keys. The keys
%                that are in the map are: keys(is_present). 

if nargin==0
    test_this();
    return;
end

assert(nargin==2)
assert(isstruct(map))
assert(isfield(map,'keySet'))
assert(isfield(map,'values'))

if ischar(map.keySet)
    keySetSize = size(map.keySet,1);
else
    keySetSize = length(map.keySet);
end


if ischar(map.values)
    valueSize = size(map.values,1);
else
    valueSize = length(map.keySet);
end


if ~valueSize==keySetSize
    error('bad map: sizes of keySet and values are different')
end

if ~strcmp(class(map.keySet),class(keys))
    error('class(keys) = ''%s'', should be class(map.keySet) = ''%s''',class(keys),class(map.keySet));
end

if ischar(keys)
    [is_present,at] = ismember(keys,map.keySet,'rows');
else
    [is_present,at] = ismember(keys,map.keySet);
end

missing = length(is_present) - sum(is_present);
if missing>0
    if nargout<2
        error('%i of keys not in map',missing);
    else
        if ischar(map.values)
            values = map.values(at(is_present),:);
        else
            values = map.values(at(is_present));
        end
    end
else
    if ischar(map.values)
        values = map.values(at,:);
    else
        values = map.values(at);
    end
end
end

function test_this()
map.keySet = ['one  ';'two  ';'three'];
map.values = ['a';'b';'c'];
maplookup(map,['one  ';'one  ';'three'])



map.keySet = {'one','two','three'};
map.values = [1,2,3];
maplookup(map,{'one','one','three'})

map.values = {'a','b','c'};
maplookup(map,{'one','one','three'})

map.keySet = [1 2 3];
maplookup(map,[1 1 3])
%maplookup(map,{1 2 3})


[values,is_present] = maplookup(map,[1 1 3 4 5])


fprintf('Now testing error message:\n');
maplookup(map,[1 1 3 4 5])
end
