function plot_DR30_both(plot_obj,plot_args_fa,plot_args_miss)
% Plots two lines indicating Doddington's Rule of 30 points: one
% for false alarms and one for misses.  See the documentation of
% plot_DR30_fa and plot_DR30_miss for details.
% Inputs:
%   plot_args_fa: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the DR30_fa point. See Matlab's help on 'plot' for information.
%   plot_args_miss: A cell array of arguments to be passed to 'plot' that control
%     the appearance of the DR30_miss point. See Matlab's help on 'plot' for information.

plot_obj.plot_DR30_fa(plot_args_fa,'pfa DR30');
plot_obj.plot_DR30_miss(plot_args_miss,'pmiss DR30');

end
