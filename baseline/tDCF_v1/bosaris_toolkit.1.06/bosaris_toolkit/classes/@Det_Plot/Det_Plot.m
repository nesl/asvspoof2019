classdef Det_Plot < handle
%  A class for creating a plot for displaying detection performance
%  with the axes scaled and labelled so that a normal Gaussian
%  distribution will plot as a straight line.
%
%    The y axis represents the miss probability.
%    The x axis represents the false alarm probability.

properties (Access = private)
  pfa_limits
  pmiss_limits
  xticks
  xticklabels
  yticks
  yticklabels
  fh
  handles_vec = []
  legend_strings = {}
  tar
  non
  sys_name
end

methods (Access = public)
  % plot_obj = Det_Plot(plot_window)
  % plot_obj = Det_Plot(plot_window,plot_title)
  function detplot = Det_Plot(plot_window,plot_title)
    detplot.pfa_limits = plot_window.pfa_limits;
    detplot.pmiss_limits = plot_window.pmiss_limits;
    detplot.xticks = plot_window.xticks;
    detplot.xticklabels = plot_window.xticklabels;
    detplot.yticks = plot_window.yticks;
    detplot.yticklabels = plot_window.yticklabels;

    detplot.prepare_plot();
    if exist('plot_title','var') && ~isempty(plot_title)
      figure(detplot.fh)
      title(plot_title);
    end
  end
  
  set_system(plot_obj,tar,non,sys_name)
  set_system_from_scores(plot_obj,scores,key,sys_name)
  plot_steppy_det(plot_obj,plot_args,legend_string)
  plot_rocch_det(plot_obj,plot_args,legend_string)
  plot_mindcf_point(plot_obj,target_prior,plot_args,legend_string)
  plot_DR30_fa(plot_obj,plot_args,legend_string)
  plot_DR30_miss(plot_obj,plot_args,legend_string)
  plot_DR30_both(plot_obj,plot_args_fa,plot_args_miss)
  display_legend(plot_obj)
  save_as_pdf(plot_obj,outfilename)
end

methods (Access = private)
  add_legend_entry(plot_obj,lh,legend_string,append_name)
end

methods (Static)
  function test_this()
    close all
    plot_obj = Det_Plot(Det_Plot.make_plot_window_from_string('sre10'),'test plot');

    tar = randn(1,1e3)+4;
    non = randn(1,1e4);

    plot_obj.set_system(tar,non,'test system');
    plot_obj.plot_rocch_det('Plotted with rocchdet','b');
    plot_obj.plot_steppy_det('Plotted with steppydet','r');
    plot_obj.display_legend();
  end
  
  function plot_window = make_plot_window_from_string(window_name)
    assert(strcmp(window_name,'new')||strcmp(window_name,'old')||strcmp(window_name,'big')||strcmp(window_name,'sre10'))
    plot_window = Det_Plot.(['axis_' window_name]);
  end
  
  function plot_window = make_plot_window_from_values(pfa_limits,pmiss_limits,xticks,xticklabels,yticks,yticklabels)
    plot_window.pfa_limits = pfa_limits;
    plot_window.pmiss_limits = pmiss_limits;
    plot_window.xticks = xticks;
    plot_window.xticklabels = xticklabels;
    plot_window.yticks = yticks;
    plot_window.yticklabels = yticklabels;
  end
  
end

methods (Static, Access = private)
  function plot_window = axis_new()
    plot_window.pfa_limits = [5e-6 5e-3];
    plot_window.pmiss_limits = [1e-2 0.99];
    plot_window.xticks = [1e-5 2e-5 5e-5 1e-4 2e-4 5e-4 1e-3 2e-3];
    plot_window.xticklabels = ['1e-3';'2e-3';'5e-3';'0.01';'0.02';'0.05';'0.1 ';'0.2 '];
    plot_window.yticks = [0.02 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95, 0.98];
    plot_window.yticklabels = [' 2 ';' 5 ';'10 ';'20 ';'30 ';'40 ';'50 ';'60 ';'70 ';'80 ';'90 '; '95 '; '98 '];
  end
  
  function plot_window = axis_old()
    plot_window.pfa_limits = [5e-4 5e-1];
    plot_window.pmiss_limits = [5e-4 5e-1];
    plot_window.xticks = [0.001 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4];
    plot_window.xticklabels = ['0.1';'0.2';'0.5';' 1 ';' 2 ';' 5 ';'10 ';'20 ';'30 ';'40 '];
    plot_window.yticks = plot_window.xticks;
    plot_window.yticklabels = plot_window.xticklabels;
  end
  
  function plot_window = axis_big()
    plot_window.pfa_limits = [5e-6 0.99];
    plot_window.pmiss_limits = [5e-6 0.99];
    plot_window.yticks = [5e-6,5e-5,5e-4,0.5e-2,2.5e-2,10e-2,25e-2,50e-2,72e-2,88e-2,96e-2,99e-2];
    plot_window.yticklabels = ['5e-4';'5e-3';'0.05';'0.5 ';'2.5 ';' 10 ';' 25 ';' 50 ';' 72 ';' 88 ';' 96 ';' 99 '];
    plot_window.xticks = plot_window.yticks(2:end);
    plot_window.xticklabels = plot_window.yticklabels(2:end,:);
  end
  
  function plot_window = axis_sre10()
    plot_window.pfa_limits = [3e-6 5e-1];
    plot_window.pmiss_limits = [3e-4 9e-1];
    plot_window.xticks = [1e-5,1e-4,1e-3,2e-3,5e-3,1e-2,2e-2,5e-2,1e-1,2e-1,4e-1];
    plot_window.xticklabels = ['0.001';' 0.01';'  0.1';'  0.2';'  0.5';'    1';'    2';'    5';'   10';'   20';'   40'];
    plot_window.yticks = [1e-3,2e-3,5e-3,1e-2,2e-2,5e-2,1e-1,2e-1,4e-1,8e-1];
    plot_window.yticklabels = ['0.1';'0.2';'0.5';' 1 ';' 2 ';' 5 ';' 10';' 20';' 40';' 80'];
  end

end

end
