function dcfplot(devkeyname,evalkeyname,devscrfilename,evalscrfilename,outfilename,plot_title,xmin,xmax,ymin,ymax,prior)
% Makes a Norm_DCF plot of the dev and eval scores for a system.  
% Inputs:
%   devkeyname: The name of the file containing the Key for
%     the dev scores.
%   evalkeyname: The name of the file containing the Key for
%     the eval scores.
%   devscrfilename: The name of the file containing the Scores
%     for the dev trials.
%   evalscrfilename: The name of the file containing the
%     Scores the eval trials.
%   outfilename: The name for the PDF file that the plot will be
%     written in.
%   plot_title: A string for the plot title. (optional)
%   xmin, xmax, ymin, ymax: The boundaries of the plot. (optional)
%   prior: The effective target prior. (optional)

assert(isa(devkeyname,'char'))
assert(isa(evalkeyname,'char'))
assert(isa(devscrfilename,'char'))
assert(isa(evalscrfilename,'char'))
assert(isa(outfilename,'char'))

if ~exist('plot_title','var') || isempty(plot_title)
    plot_title = '';
end

if ~exist('xmin','var')
    xmin = -10;
    xmax = 0;
    ymin = 0;
    ymax = 1.2;
    prior = 0.001;
end

[dev_tar,dev_non] = get_tar_non_scores(devscrfilename,devkeyname);
[eval_tar,eval_non] = get_tar_non_scores(evalscrfilename,evalkeyname);

close all
plot_obj = Norm_DCF_Plot([xmin,xmax,ymin,ymax],plot_title);
plot_obj.set_system(dev_tar,dev_non,'dev')
plot_obj.plot_operating_point(logit(prior),'m--','new DCF point')
plot_obj.plot_curves([0 0 0 1 1 1 0 0],{{'b--'},{'g--'},{'r--'}})
plot_obj.set_system(eval_tar,eval_non,'eval')
plot_obj.plot_curves([0 0 1 1 1 1 0 1],{{'r','LineWidth',2},{'b'},{'g'},{'r'},{'k*'}})
plot_obj.display_legend()
plot_obj.save_as_pdf(outfilename)
end

function [tar,non] = get_tar_non_scores(scrfilename,keyname)
key = Key.read(keyname);
scr = Scores.read(scrfilename);
[tar,non] = scr.get_tar_non(key);
end
