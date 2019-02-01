function [frr, far, thresholds] = compute_det_curve(target_scores, nontarget_scores)

n_scores = length(target_scores) + length(nontarget_scores);
all_scores = [target_scores; nontarget_scores];
labels = [ones(length(target_scores), 1); zeros(length(nontarget_scores), 1)];

% Sort labels based on scores
[thresholds, indices] = sort(all_scores);
labels = labels(indices);

% Compute false rejection and false acceptance rates
tar_trial_sums = cumsum(labels);
nontarget_trial_sums = length(nontarget_scores) - ((1:n_scores)' - tar_trial_sums);

frr = [0; tar_trial_sums / length(target_scores)];  % false rejection rates
far = [1; nontarget_trial_sums / length(nontarget_scores)];  % false acceptance rates
thresholds = [thresholds(1) - 0.001; thresholds];  % Thresholds are the sorted scores