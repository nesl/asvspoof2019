function qual_obj_array = load_qual_files(filenames)
% This function loads quality measures from files into an array of
% Quality objects.
% Inputs:
%   filenames: A list of files containing quality measures.
% Output:
%   qual_obj_array: An array of Quality objects containing the same
%     number of elements as filenames.

assert(iscell(filenames))

num_systems = length(filenames);
qual_obj_array = Quality.empty(num_systems,0);

log_info('quality:\n');

for ii=1:num_systems
    qual_obj_array(ii) = Quality.read(filenames{ii});
    log_info(' %s\n',filenames{ii});
end
