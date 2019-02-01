function fused_scr = apply_linear_fusion_function(key_or_ndx,scores_obj_array,flin)
% Preforms linear fusion by applying a linear fusion function to a
% set of scores.
% Inputs:
%   key_or_ndx: A Key or Ndx object describing the scores.
%   scores_obj_array: An array of score objects (one object for
%     each system) to be fused.
%   flin: The linear fusion function.
% Outputs:
%   fused_scr: An object of type Scores containing the fused
%     scores. 

stacked_scores = stackScores(key_or_ndx,scores_obj_array);
fused_scores = flin(stacked_scores)';
fused_scr = assemble_scr(fused_scores,key_or_ndx);
end
