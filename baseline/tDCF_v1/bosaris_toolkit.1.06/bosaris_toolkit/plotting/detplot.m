function detplot(scrfilename,keyfilename,outfilename,prior,plot_title,curve_label)
% This function makes a DET plot using the information in the input
% files.  It takes a single score and key file and produces a
% single PDF file containing the plot.  The plot has a single DET
% curve.
% Inputs:
%   scrfilename: The name of the file containing the scores.
%   keyfilename: The name of the file containing the Key for
%     the scores.
%   outfilename: The name for the output PDF files.
%   prior: The effective target prior.
%   plot_title: Optional.  The title for the plot.
%   curve_label: Optional.  A label for the curve in the legend.

assert(isa(scrfilename,'char'))
assert(isa(keyfilename,'char'))
assert(isa(outfilename,'char'))

if ~exist('plot_title','var')
    plot_title = '';
end

if ~exist('curve_label','var')
    curve_label = '';
end

key = Key.read(keyfilename);
scr = Scores.read(scrfilename);

plot_type = Det_Plot.make_plot_window_from_string('sre10');
plot_obj = Det_Plot(plot_type,plot_title);
plot_obj.set_system_from_scores(scr,key);
plot_obj.plot_steppy_det('b',curve_label);
plot_obj.plot_mindcf_point(prior,'k*','min dcf');
plot_obj.display_legend();
plot_obj.save_as_pdf(outfilename);
end
