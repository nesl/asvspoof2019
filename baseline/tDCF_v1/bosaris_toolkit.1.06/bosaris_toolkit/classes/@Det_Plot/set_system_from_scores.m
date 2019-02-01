function set_system_from_scores(plot_obj,scr,key,sys_name)
% Sets the scores to be plotted.  This function must be called
% before plots are made for a system, but it can be called several
% times with different systems (with calls to plotting functions in
% between) so that curves for different systems appear on the same
% plot.  
% Inputs:
%   scr: A Scores object containing system scores.
%   key: A Key object for distinguishing target and non-target scores.
%   sys_name: A string describing the system.  This string will be
%     prepended to the plot names in the legend.  You can pass an
%     empty string to this argument or omit it. 

assert(isa(scr,'Scores'))
assert(isa(key,'Key'))
assert(scr.validate())
assert(key.validate())

if ~exist('sys_name','var')
    sys_name = '';
end

[tar,non] = scr.get_tar_non(key);

plot_obj.set_system(tar,non,sys_name);
end
