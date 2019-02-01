function save_as_pdf(plot_obj,outfilename)
% Saves the plot to a PDF file.  
% Inputs:
%   outfilename: The name of the PDF file in which the plot will be
%     saved. 

assert(ischar(outfilename))
saveas(plot_obj.fh,outfilename,'pdf');
end
