function plot_operating_point(plot_obj,value,plot_args,legend_string)
% Plots a vertical line on the plot indicating an operating point.
% Inputs:
%   value: The position on the x-axis of the vertical line.  
%   plot_args: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this line in the legend.
%     The system name will not be prepended to this string.

if ischar(plot_args)
    plot_args = {plot_args};
end

xmin = plot_obj.plot_axes(1);
xmax = plot_obj.plot_axes(2);

if (value < xmin) || (value > xmax)
    log_warning('Operating point of %f is not between %f and %f. The line will not be plotted.\n',value,xmin,xmax)
else
    ymin = plot_obj.plot_axes(3);
    ymax = plot_obj.plot_axes(4);
    figure(plot_obj.fh);
    assert(iscell(plot_args))
    lh = plot([value,value],[ymin,ymax],plot_args{:});

    if exist('legend_string','var') && ~isempty(legend_string)
	assert(ischar(legend_string))
	plot_obj.add_legend_entry(lh,legend_string,false);
    end
end

end
