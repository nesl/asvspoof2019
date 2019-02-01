function plot_rocch_det(plot_obj,plot_args,legend_string)
% Plots a DET curve using the ROCCH.
% Inputs:
%   plot_args: A cell array of arguments to be passed to plot that control
%     the appearance of the curve. See Matlab's help on 'plot' for information.
%   legend_string: Optional. A string to describe this curve in the legend.

if ischar(plot_args)
    plot_args = {plot_args};
end

pfa_min = plot_obj.pfa_limits(1);
pfa_max = plot_obj.pfa_limits(2);
pmiss_min = plot_obj.pmiss_limits(1);
pmiss_max = plot_obj.pmiss_limits(2);

figure(plot_obj.fh);
dps = 100; %dots per segment
[x,y] = rocchdet(plot_obj.tar,plot_obj.non,[],pfa_min,pfa_max,pmiss_min,pmiss_max,dps);
assert(iscell(plot_args))
lh = plot(x,y,plot_args{:});

if exist('legend_string','var') && ~isempty(legend_string)
    assert(ischar(legend_string))
    plot_obj.add_legend_entry(lh,legend_string,true);
end

end
