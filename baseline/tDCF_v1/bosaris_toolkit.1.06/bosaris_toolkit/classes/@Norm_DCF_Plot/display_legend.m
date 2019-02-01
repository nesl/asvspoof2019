function display_legend(plot_obj)
% Displays the legend on the plot.  Call this function only once
% all curves have been plotted.

if length(plot_obj.legend_strings) > 0
    figure(plot_obj.fh)
    legend(plot_obj.handles_vec,plot_obj.legend_strings)
end
end
