classdef Norm_DCF_Plot < handle
% This class is for plotting normalized DCF curves from the 
% scores of a given detector, as a function of the effective target
% prior. The DCF is parametrized by the prior and has unity cost
% for both misses and false alarms. The algorithms to compute DCF
% have been optimized to allow the use of large score sets, in
% order to be able to obtain meaningful results at extreme
% operating points.
%
% There are six curves that can be plotted: 
% (i) minimum DCF, where the evaluator chooses the optimal decision 
%     threshold at every operating point. (The operating point is defined 
%     by the effective target prior).
% (ii) actual DCF, where the decision threshold is the 
%      minimum-probability-of-error Bayes decision threshold, assuming that
%      the given detector scores are log-likelihood-ratios. This decision
%      threshold is just -logit(Ptar). 
% (iii) actual misses, the component of actual DCF due to miss errors.
% (iv) actual false alarms, the component of actual DCF due to false-alarm errors.
% (v) minimum misses, the component of minimum DCF due to miss errors.
% (vi) miniumu false alarms, the component of minimum DCF due to false-alarm errors.
%
% All curves are normalized by dividing by the DCF of the default system 
% that makes decisions based on the prior alone. The normalization is
% min(Ptar,1-Ptar).
%
% The x-axis is logit(Ptar) = log(Ptar) - log(1-Ptar). The logit
% transformation maps the effective target prior to the whole
% extended real line from -inf to inf, but this plot is confined to
% the given limits xmin and xmax.
% 
% For more information on DCF, type:
% > help fast_actDCF
% > help fast_minDCF
%
% Use set_system with the target and non-target scores for a system
% before calling the plotting functions.  The curves plotted will
% all be for the current set system.  Curves for more than one
% system can be plotted by calling set_system for the first system,
% plotting all of its curves and points of interest, calling
% set_system for the second system, plotting, etc.
%
% Inputs: 
%    plot_axes: [xmin,xmax,ymin,ymax]: the range for the x-axis and
%      y-axis of this plot, where x = logit(Ptar).
%
%    plot_title: An optional title string for the plot.
%

properties (Access = private)
  fh
  plot_axes
  sys_name
  plo
  actDCF
  actPmiss
  actPfa
  minDCF
  minPmiss
  minPfa
  dr30Miss
  dr30FA
  Ptar_norm
  Pnon_norm
  handles_vec
  legend_strings = {};
end

methods (Access = public)
  set_system(plot_obj,tar,non,sys_name)
  set_system_from_scores(plot_obj,scores,key,sys_name)
  plot_fa_rate_min(plot_obj,plot_args,legend_string)
  plot_fa_rate_act(plot_obj,plot_args,legend_string)
  plot_miss_rate_min(plot_obj,plot_args,legend_string)
  plot_miss_rate_act(plot_obj,plot_args,legend_string)
  plot_dcf_curve_min(plot_obj,plot_args,legend_string)
  plot_dcf_curve_act(plot_obj,plot_args,legend_string)
  plot_DR30_fa(plot_obj,plot_args,legend_string)
  plot_DR30_miss(plot_obj,plot_args,legend_string)
  plot_DR30_both(plot_obj,plot_args_fa,plot_args_miss)
  plot_curves(plot_obj,mask,line_info)
  plot_operating_point(plot_obj,value,plot_args,legend_string)
  display_legend(plot_obj)
  save_as_pdf(plot_obj,outfilename)
end

methods (Access = public)
  % plot_obj = Norm_DCF_Plot()
  % plot_obj = Norm_DCF_Plot(plot_axes)
  % plot_obj = Norm_DCF_Plot(plot_axes,plot_title)
  function plot_obj = Norm_DCF_Plot(plot_axes,plot_title)
  % constructor
  if exist('plot_axes','var') && ~isempty(plot_axes)
    assert(length(plot_axes)==4)
    plot_obj.plot_axes = plot_axes;
  else
    plot_obj.plot_axes = [-10,0,0,1.2];
  end
  xmin = plot_obj.plot_axes(1);
  xmax = plot_obj.plot_axes(2);
  assert(xmin<xmax,'Illegal parameters xmin and xmax.')
  step = (xmax-xmin)/1000;
  plot_obj.plo = xmin:step:xmax;
  Ptar = sigmoid(plot_obj.plo);
  Pnon = sigmoid(-plot_obj.plo);
  refPe = min(Ptar,Pnon);
  plot_obj.Ptar_norm = Ptar ./ refPe;
  plot_obj.Pnon_norm = Pnon ./ refPe;
  plot_obj.actDCF = [];
  plot_obj.handles_vec = [];
  plot_obj.legend_strings = {};
  
  plot_obj.fh = figure();
  hold on
  ylabel('normalized DCF');
  xlabel('logit P_{tar}');
  grid
  axis(plot_obj.plot_axes);
  if exist('plot_title','var') && ~isempty(plot_title)
    title(plot_title);
  end    
  end
end

methods (Access = private)
  add_legend_entry(plot_obj,lh,legend_string,append_name)
  plot_miss_rate(plot_obj,Pmiss,plot_args,legend_string)
  plot_fa_rate(plot_obj,Pfa,plot_args,legend_string)
  plot_dcf_curve(plot_obj,dcf,plot_args,legend_string)
end

end
