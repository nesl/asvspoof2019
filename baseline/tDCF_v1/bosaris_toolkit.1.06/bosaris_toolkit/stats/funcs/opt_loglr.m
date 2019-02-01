function [tar_llrs,nontar_llrs] = opt_loglr(tar_scores,nontar_scores,option);
%OPT_LOGLR: Non-parametric optimization of score to log-likelihood-ratio mapping. 
%
%   [tar_llrs,nontar_llrs] = OPT_LOGLR(tar_scores,nontar_scores)
%   [tar_llrs,nontar_llrs] = OPT_LOGLR(tar_scores,nontar_scores,'raw')
%
%   Input Parameters
%     tar_scores, nontar_scores: arrays of target and non-target scores
%
%   Output Parameters
%     tar_llrs, nontar_llrs: arrays of corresponding log-likelihood ratios, 
%     one for each input score.
%
%   option
%     'laplace': (default) avoids logLR's of infinite magnitude, see below.  
%     'raw': allows logLR's of infinite magnitude  
%
%   Description:
%     The output log-LR values are non-parametrically and (almost) independently optimized, 
%     subject only to the constraint that the mapping from score to log-LR must be 
%     non-decreasing. 
%     Remarkably the mapping thus obtained is empirically optimal (on the input data and subject 
%     to the constraint) for any cost function at 
%     any prior. 
%     
%     N.B. but note that a mapping thus obtained on training data cannot of course be assumed 
%     to have the same universal optimality on new test data. The primary application of this 
%     procedure is to obtain a TEST STANDARD similar to "minimum Cdet". Minimum Cdet is based 
%     on a threshold optimized on the evaluation data, again subject only to a non-decreasing 
%     mapping. 
%
%     The mapping obtained here is a generalization of the minimum Cdet threshold: 
%     The whole score to LR mapping is optimized. The minimum Cdet threshold can be read 
%     from this mapping, but we can also read multiple thresholds for more complicated 
%     applications that for example require a decision of the form Accept/Reject/Undecided.
%
%     Note on empirical test error:
%       A straight-forward implementation leads to log-LR values of infinite 
%       magnitude for 
%       (a) all target scores that exceed the largest non-target score
%       (b) all non-target scores smaller than the smallest target score. 
%       The following is a strategy to assign finite log-LR values to these cases. 
%       Setting option='raw' switches this mechanism off and will most probably result 
%       in some infinite values.
%
%       Laplace's rule of succession:
%         Before seeing any scores, our prior knowledge about target scores states:
%         - Target scores may be concentrated in a small score range,
%         - but to keep the test procedure objective, we don't want to make any assumptions 
%         about where this concentration is. (The score mean can be anywhere.)
%         One way to state this mathematically is:
%           - Given any finite score threshold t, we define theta = P(score > t). 
%           - Since we don't know where the score is concentrated we have a uniform prior over 
%         the parameter theta: P(theta|t) = 1, for any t.
%         Now given this distribution, we can count the number of target scores that 
%         exceed a threshold t:
%         Let there be N target scores in total of which M exceed the threshold t. 
%         Then the Bayesian predictive probability to get another score above 
%         t is (M+1)/(N+2), instead of the usual M/N. This is known as the rule of succession.
%         - See e.g. http://en.wikipedia.org/wiki/Rule_of_succession.
%         This rule can be effectively implemented, for every value of t, by simply adding a 
%         dummy target score at each of -inf and +inf. 
%         The same is applied to non-target scores. By doing this we are acknowledging the fact 
%         that there is a possibility to get scores outside the ranges seen in the test data.
%
%         P.S.1. A similar strategy was used in 
%         Platt, "Probabilistic Outputs for Support Vector Machines... "
%         http://research.microsoft.com/~jplatt/abstracts/SVprob.html
%
%         P.S.2. Try this when plotting DET curves! It stops DET's from curling to the axes when the 
%         data is sparse, but leaves well-populated regions unchanged. 


% Author: Niko Brummer, Spescom Datavoice.
%         nbrummer@za.spescom.com
% Disclaimer: This code is freely available for any non-commercial purpose, but the author and 
% his employer do not accept any responsibility for any consequences resulting from the use thereof.
% (E.g. getting an EER=50% at the NIST SRE.) 
%
% But if this code does prove useful, we would appreciate citation of the following article:
%   Niko Brummer and Johan du Preez, "Application-Independent Evaluation of Speaker Detection", 
%   Computer Speech and Language, to be published, 2005. 


if (nargin<3)
   option = 'laplace';
end

Nt = length(tar_scores);
Nn = length(nontar_scores);
N = Nt+Nn;

% The 'sort' function in Matlab preserves the indexing ordering for values which are exactly the same.
% Thus, putting the target scores first in the ordering chooses the pesimistic option: if a target
% and a non-target score have the same value, the target score will be assumed to be lower.
% This is necessary so that min_cllr(0,0) returns 1, not 0. 
% It boils down to saying that when a target and a non-target have the same
% score, it is bad, not good.
scores = [tar_scores,nontar_scores];
Pideal = [ones(1,Nt),zeros(1,Nn)];  %ideal, but non-monotonic posterior

[scores,perturb] = sort(scores);
Pideal = Pideal(perturb);  


if (strcmp(option,'laplace'))
   Pideal = [1,0,Pideal,1,0];  
   % The extra targets and non-targets at scores of -inf and +inf effectively 
   % implement Laplace's rule of succession to avoid log LRs of infinite magnitudes. 
end

% Pool Adjacent Violators Algorithm. Gets a non-decreasing posterior Popt "closest" to Pideal.
% Remarkably this is valid for "closeness" as defined by any proper scoring rule.
% It will therefore minimize the cost of decisions based on Popt, for any cost-based penalty.
Popt = pavx(Pideal); 

if (strcmp(option,'laplace'))
% lose the extras
  Popt = Popt(3:length(Popt)-2);
end

%posterior to loglr
%This LR is prior-independent in the sense that if we weight the data with a synthetic prior, 
% it makes no difference to the optimizing LR mapping. 
% (A synthetic prior DOES change Popt: The posterior log-odds changes by an additive term. But this 
% this cancels again when converting to log LR. )

%state = warning;
%warning off;  % otherwise 'raw' option would produce 'log(0)' warnings
posterior_log_odds = log(Popt)-log(1-Popt);
%eval(['warning ',state.state]); % restore previous warning state
log_prior_odds = log((Nt)/(Nn)); 

% log_prior_odds=0.5

llrs = posterior_log_odds - log_prior_odds;

llrs = llrs + [1:N]*1.0e-6/N; % to preserve monotonicity. This ensures opt_loglr is idempotent.

%unsort and unpack
llrs(perturb) = llrs;
tar_llrs = llrs(1:Nt);
nontar_llrs = llrs(Nt+1:Nn+Nt);
