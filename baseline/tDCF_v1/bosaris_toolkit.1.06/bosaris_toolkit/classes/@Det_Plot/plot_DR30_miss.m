function plot_DR30_miss(plot_obj,plot_args,legend_string)
% Plots a horizontal line indicating the Doddington 30 point for
% misses.  This is the point above which the number of misses is
% below 30, so that the estimate of the miss rate is no longer good
% enough to satisfy Doddington's Rule of 30.
% Inputs:
%   plot_args: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this curve in the legend.

if ischar(plot_args)
    plot_args = {plot_args};
end

pmiss_min = plot_obj.pmiss_limits(1);
pmiss_max = plot_obj.pmiss_limits(2);

pmissval = 30/length(plot_obj.tar);

if (pmissval < pmiss_min) || (pmissval > pmiss_max)
    log_warning('Pmiss DR30 of %f is not between %f and %f. Pmiss DR30 line will not be plotted.\n',pmissval,pmiss_min,pmiss_max)
else
    pfa_min = plot_obj.pfa_limits(1);
    pfa_max = plot_obj.pfa_limits(2);

    figure(plot_obj.fh);
    dry = probit(pmissval);
    assert(iscell(plot_args))
    lh = plot([probit(pfa_min),probit(pfa_max)],[dry,dry],plot_args{:});

    if exist('legend_string','var') && ~isempty(legend_string)
	assert(ischar(legend_string))
	plot_obj.add_legend_entry(lh,legend_string,true);
    end
end

end
