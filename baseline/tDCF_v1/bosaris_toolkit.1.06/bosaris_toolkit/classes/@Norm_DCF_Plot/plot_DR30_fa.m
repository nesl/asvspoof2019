function plot_DR30_fa(plot_obj,plot_args,legend_string)
% Plots the point on the minDCF curve at which the number of false
% alarms falls below 30 (see Doddington's Rule of 30).
% Inputs:
%   plot_args: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this curve in the legend.
%     This string will be prepended with the system name.

if ischar(plot_args)
    plot_args = {plot_args};
end

figure(plot_obj.fh);
assert(iscell(plot_args))
lh = plot(plot_obj.plo(plot_obj.dr30FA),plot_obj.minDCF(plot_obj.dr30FA),plot_args{:});

if exist('legend_string','var') && ~isempty(legend_string)
    assert(ischar(legend_string))
    plot_obj.add_legend_entry(lh,legend_string,true);
end

end
