function ndx = to_ndx(key)
% Returns an Ndx based on the Key.
% Inputs:
%   key: An object of type Key.
% Outputs:
%   ndx: An object of type Ndx.

assert(nargin==1)
assert(isa(key,'Key'))
assert(key.validate())

ndx = Ndx();
ndx.modelset = key.modelset;
ndx.segset = key.segset;
ndx.trialmask = key.tar | key.non;
