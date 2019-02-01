function qual = stackQ(ndx,qual_obj_array)
% This function loads quality measures from files and creates a
% single Quality object containing them.  If two input files are
% given, the quality measures from the second file are appended to
% those from the first file.
% Inputs:
%   ndx: A Key or Ndx object indicating trials.
%   qual_obj_array: An array of Quality objects; one for each system.
% Output:
%   qual: An object of type Quality containing the quality measures
%     from all the input objects.

assert(nargin==2)
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))

num_systems = length(qual_obj_array);
qual = qual_obj_array(1).align_with_ndx(ndx);
for ii=2:num_systems
    qual = spliceQ(qual,qual_obj_array(ii),ndx);
end
