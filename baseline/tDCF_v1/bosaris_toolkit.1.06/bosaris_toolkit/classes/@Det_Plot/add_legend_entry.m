function add_legend_entry(plot_obj,lh,legend_string,append_name)
% Places a (curve handle, legend string) pair in a list for when
% display_legend is called.
% Inputs:
%   lh: A curve handle.
%   legend_string: The string to be displayed in the legend for the
%     curve corresponding to lh.
%   append_name: A boolean indicating whether to prepend the system
%     name (set in 'set_system') to the 'legend_string'.

if ~strcmp(legend_string,'')
    plot_obj.handles_vec = [plot_obj.handles_vec lh];
    if exist('append_name','var') && append_name
	plot_obj.legend_strings = {plot_obj.legend_strings{:},[plot_obj.sys_name ' ' legend_string]};
    else
	plot_obj.legend_strings = {plot_obj.legend_strings{:},legend_string};        
    end
end

end
