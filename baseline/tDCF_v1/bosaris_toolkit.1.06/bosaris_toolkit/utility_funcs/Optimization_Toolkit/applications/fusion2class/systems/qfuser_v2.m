function [fusion,params] = qfuser_v2(w,scores)
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


% Create building blocks
[Cal,params1] = parallel_cal_augm([],scores.scores);
m = size(scores.scores,1)+1;
[P,params2] = QQtoP(params1.tail,scores.modelQ,scores.segQ,m);

%params.get_w0 = @(wfuse) [params1.get_w0() ;params2.get_w0()];
params.get_w0 = @(wfuse) [params1.get_w0(wfuse) ;params2.get_w0()];
params.tail = params2.tail;



% Assemble building blocks

%  modulate linear fusion with quality
fusion = sumcolumns_fh(m,dottimes_of_functions(w,P,Cal));



end


function test_this()

m = 3;
k = 2;
n1 = 4;
n2 = 5;

scores.scores = randn(m,n1*n2);
scores.modelQ = randn(k,n1);
scores.segQ = randn(k,n2);

[fusion,params] = qfuser_v2([],scores);

w0 = params.get_w0();
test_MV2DF(fusion,w0);

fusion(w0)

end
