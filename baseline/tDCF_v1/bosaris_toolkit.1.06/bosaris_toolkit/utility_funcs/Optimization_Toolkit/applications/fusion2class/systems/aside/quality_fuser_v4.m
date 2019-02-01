function [fusion,params] = quality_fuser_v4(w,scores,quality_inputs)
% 
% Inputs:
%
%    scores: the primary detection scores, for training
%            D-by-T matrix of T scores for D input systems
%
%    quality_input: K-by-T matrix of quality measures
%
% Output:  
%    fusion: is numeric if w is numeric, or a handle to an MV2DF, representing:
%
%      y= (alpha'*scores+beta) * sigmoid( gamma'*quality_inputs + delta)
%

if nargin==0
    test_this();
    return;
end

% Check data dimensions
[D,T] = size(scores);
[K,T2] = size(quality_inputs);
assert(T==T2);


% Create building blocks

[linfusion,params1] = linear_fuser([],scores);
[quality,params2] = fused_sigmoid(params1.tail,quality_inputs);

params.get_w0 = @(ssat) [params1.get_w0(); params2.get_w0(ssat)];
params.tail = params2.tail;



% Assemble building blocks

%  modulate linear fusion with quality
fusion = dottimes_of_functions([],quality,linfusion);


if ~isempty(w)
    fusion = fusion(w);
end

end


function test_this()

D = 4;
T = 5;
K = 3;
scores = randn(D,T);
Q = randn(K,T);

ssat = 0.99;
[fusion,params] = quality_fuser_v4([],scores,Q);

w0 = params.get_w0(ssat);
test_MV2DF(fusion,w0);

w0(D+1)=1;
quality_fuser_v4(w0,scores,Q),

end
