function [mindcf,pmiss,pfa] = plot_mindcf_point(plot_obj,target_prior,plot_args,legend_string)
% Places the mindcf point for the current system.
% Inputs:
%   target_prior: The effective target prior.
%   plot_args: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this curve in the legend.

if ischar(plot_args)
    plot_args = {plot_args};
end

[mindcf,pmiss,pfa] = fast_minDCF(plot_obj.tar,plot_obj.non,logit(target_prior),true);
if (pfa < plot_obj.pfa_limits(1)) || (pfa > plot_obj.pfa_limits(2))
    log_warning('pfa of %f is not between %f and %f. The mindcf point will not be plotted.\n',pfa,plot_obj.pfa_limits(1),plot_obj.pfa_limits(2))
elseif (pmiss < plot_obj.pmiss_limits(1)) || (pmiss > plot_obj.pmiss_limits(2))
    log_warning('pmiss of %f is not between %f and %f. The mindcf point will not be plotted.\n',pmiss,plot_obj.pmiss_limits(1),plot_obj.pmiss_limits(2))    
else
    figure(plot_obj.fh);
    assert(iscell(plot_args))
    lh = plot(probit(pfa),probit(pmiss),plot_args{:});
    if exist('legend_string','var') && ~isempty(legend_string)
	assert(ischar(legend_string))
	plot_obj.add_legend_entry(lh,legend_string,true);
    end
end

end
