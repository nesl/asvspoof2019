function fused_scr = apply_quality_fusion_function(key_or_ndx,scores_obj_array,qual_obj_array,Qtrans,fqual,scr_lin)
% Preforms quality fusion by applying a fusion function (trained
% with quality measures) to a set of scores and a set of quality measures.
% Inputs:
%   key_or_ndx: A Key or Ndx object describing the scores.
%   scores_obj_array: An array of score objects (one object for
%     each system) to be fused.
%   qual_obj_array: An array of quality measure objects.
%   Qtrans: A matrix indicating how the quality measures should be
%     combined.  Use an identity matrix of
%     size(numsystems,numsystems) if you want the quality measures
%     to be used as is. 
%   fqual: The fusion function.
%   scr_lin: An object of type Scores containing the linear fusion
%     of the scores in 'scores_obj_array'.
% Outputs:
%   fused_scr: An object of type Scores containing the fused
%     scores. 

stacked_scores = stackScores(key_or_ndx,scores_obj_array);
stackedQ = stackQ(key_or_ndx,qual_obj_array);
scrQ = applyQtrans(stackedQ,Qtrans);
if isa(key_or_ndx,'Ndx')
    trialmask = key_or_ndx.trialmask;
else
    trialmask = key_or_ndx.tar | key_or_ndx.non;
end
lin_fusion = scr_lin.scoremat(trialmask(:));
fused_scores = fqual(stacked_scores,scrQ,key_or_ndx,lin_fusion)';
fused_scr = assemble_scr(fused_scores,key_or_ndx);
end
