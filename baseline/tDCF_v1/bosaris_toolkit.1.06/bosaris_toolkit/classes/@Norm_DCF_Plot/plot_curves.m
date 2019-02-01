function plot_curves(plot_obj,mask,line_info)
% Plots several curves for a system at once.  Call 'set_system'
% before using this function.  
% Inputs:
%   mask: A vector of eight zeroes and ones indicating which curves
%     to plot. The entries have the following meanings:
%     1) miss rate contribution to minimum dcf
%     2) FA rate contribution to minimum dcf
%     3) minimum dcf curve
%     4) miss rate contribution to actual dcf
%     5) FA rate contribution to actual dcf
%     6) actual dcf curve
%     7) DR30 point for misses
%     8) DR30 point for false alarms
%   line_info: A cell array of cell arrays of values indicating
%     the colour and line style for the curve.  Each inner cell
%     array is expanded and passed as a sequence of values to the
%     plot function.  See Matlab's help on 'plot' for information. 

assert(isvector(mask))
assert(length(mask)==8)
truepos = find(mask>0);
numtrue = length(truepos);
backmap = zeros(1,8);
backmap(truepos) = 1:numtrue;
assert(isa(line_info,'cell'))
assert(length(line_info)==numtrue)
func_name = {'miss_rate_min','fa_rate_min','dcf_curve_min','miss_rate_act','fa_rate_act','dcf_curve_act','DR30_miss','DR30_fa'};
legend_strings = {'min miss rate','min FA rate','min dcf','act miss rate','act FA rate','act dcf','Miss DR30','FA DR30'};
for ii=1:8
    if mask(ii)
	plot_obj.(['plot_' func_name{ii}])(line_info{backmap(ii)},legend_strings{ii});
    end
end
end
