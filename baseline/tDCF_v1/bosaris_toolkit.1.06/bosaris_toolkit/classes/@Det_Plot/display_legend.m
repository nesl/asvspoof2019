function display_legend(plot_obj)
% Displays the legend on the plot.  Call this function after all
% curves and points have been plotted.  The only function that
% should be called after this one is the one for saving the plot.
% Legend entries for curves are stored with add_legend_entry.

if length(plot_obj.legend_strings) > 0
    figure(plot_obj.fh)
    legend(plot_obj.handles_vec,plot_obj.legend_strings)
end
end
