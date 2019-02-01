function plot_DR30_fa(plot_obj,plot_args,legend_string)
% Plots a vertical line indicating the Doddington 30 point for
% false alarms. This is the point left of which the number of false
% alarms is below 30, so that the estimate of the false alarm rate
% is no longer good enough to satisfy Doddington's Rule of 30.
% Inputs:
%   plot_args: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this curve in the legend.

if ischar(plot_args)
    plot_args = {plot_args};
end

pfa_min = plot_obj.pfa_limits(1);
pfa_max = plot_obj.pfa_limits(2);
pfaval = 30/length(plot_obj.non);

if (pfaval < pfa_min) || (pfaval > pfa_max)
    log_warning('Pfa DR30 of %f is not between %f and %f. Pfa DR30 line will not be plotted.\n',pfaval,pfa_min,pfa_max)
else
    pmiss_min = plot_obj.pmiss_limits(1);
    pmiss_max = plot_obj.pmiss_limits(2);

    figure(plot_obj.fh);
    drx = probit(pfaval);
    assert(iscell(plot_args))
    lh = plot([drx,drx],[probit(pmiss_min),probit(pmiss_max)],plot_args{:});

    if exist('legend_string','var') && ~isempty(legend_string)
	assert(ischar(legend_string))
	plot_obj.add_legend_entry(lh,legend_string,true);
    end
end

end
