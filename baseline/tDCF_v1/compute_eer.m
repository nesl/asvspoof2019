function [eer, eer_t] = compute_eer(target_scores, nontarget_scores)

% function [eer, eer_t] = compute_eer(target_scores, nontarget_scores)
% Returns equal error rate (EER) and the corresponding threshold.

[frr, far, thresholds] = compute_det_curve(target_scores(:), nontarget_scores(:));
abs_diffs = abs(frr - far);
[~, min_index] = min(abs_diffs);
eer = mean([frr(min_index), far(min_index)]);
eer_t = thresholds(min_index);