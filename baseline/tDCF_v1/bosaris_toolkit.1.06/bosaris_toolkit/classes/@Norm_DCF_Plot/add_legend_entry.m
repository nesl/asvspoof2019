function add_legend_entry(plot_obj,lh,legend_string,append_name)
% A private method that stores legend information for when
% 'display_legend' is called.
% Inputs:
%   lh: The handle for the curve.
%   legend_string: A string describing the curve.
%   append_name: A boolean indicating whether to prepend the system
%     name (set in 'set_system') to the 'legend_string'.

assert(ischar(legend_string))

if ~strcmp(legend_string,'')
    plot_obj.handles_vec = [plot_obj.handles_vec lh];
    if exist('append_name','var') && append_name
	plot_obj.legend_strings = {plot_obj.legend_strings{:},[plot_obj.sys_name ' ' legend_string]};
    else
	plot_obj.legend_strings = {plot_obj.legend_strings{:},legend_string};        
    end
end
end
