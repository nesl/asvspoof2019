function save_as_pdf(plot_obj,outfilename)
% Save the DET plot in a PDF file
% Inputs:
%   outfilename: The name of the PDF file to save the plot in.

assert(ischar(outfilename))

saveas(plot_obj.fh,outfilename,'pdf');
end
