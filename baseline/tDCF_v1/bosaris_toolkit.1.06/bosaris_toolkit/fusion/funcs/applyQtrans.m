function out_qual = applyQtrans(in_qual,Qtrans)
% Combines (or discards) quality measures according to information
% supplied in Qtrans.
% Inputs:
%   in_qual: An object of type Quality containing quality measures.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is. 
% Outputs:
%   out_qual: An object of type Quality containing the quality
%     measures in in_qual modified according to Qtrans.

logprint(Logger.Info,'Qtrans = \n%s',sprintfmatrix(Qtrans));
out_qual = in_qual;
out_qual.modelQ = Qtrans*in_qual.modelQ;
out_qual.segQ = Qtrans*in_qual.segQ;
end
