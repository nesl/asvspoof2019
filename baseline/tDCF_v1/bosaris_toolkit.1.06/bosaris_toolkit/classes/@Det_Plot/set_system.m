function set_system(plot_obj,tar,non,sys_name)
% Sets the scores to be plotted.  This function must be called
% before plots are made for a system, but it can be called several
% times with different systems (with calls to plotting functions in
% between) so that curves for different systems appear on the same
% plot.  
% Inputs:
%   tar: A vector of target scores.
%   non: A vector of non-target scores.
%   sys_name: A string describing the system.  This string will be
%     prepended to the plot names in the legend.  You can pass an
%     empty string to this argument or omit it. 

assert(isvector(tar))
assert(isvector(non))
assert(length(tar)>0)
assert(length(non)>0)

if exist('sys_name','var') && ~isempty(sys_name)
    plot_obj.sys_name = sys_name;
else
    plot_obj.sys_name = '';
end

plot_obj.tar = tar;
plot_obj.non = non;
end
