function [fusion,params] = quality_fuser_v3(w,scores,train_vecs,test_vecs,train_ndx,test_ndx,ddim)
% 
% Inputs:
%
%    scores: the primary detection scores, for training
%            D-by-T matrix of T scores for D input systems
%
%    train_vecs: K1-by-M matrix, one column-vector for each of M training
%                segemnts
%
%    test_vecs: K2-by-N matrix, one column-vector for each of N training
%               segemnts
%
%    train_ndx: 1-by-T index where train_ndx(t) is the index into train_vecs
%               for trial t. 
%
%    test_ndx: 1-by-T index where test_ndx(t) is the index into test_vecs
%              for trial t. 
%    ddim: dimension of subspace for quality distandce calculation,
%          where ddim <= min(K1,K2)
%
% Outputs:
%

if nargin==0
    test_this();
    return;
end

% Check data dimensions
[K1,M] = size(train_vecs);
[K2,N] = size(test_vecs);
assert(ddim<min(K1,K2));

[D,T] = size(scores);
assert(T == length(train_ndx));
assert(T == length(test_ndx));
assert(max(train_ndx)<=M);
assert(max(test_ndx)<=N);


% Create building blocks

[linfusion,params1] = linear_fuser([],scores);

[quality,params2] = sigmoid_log_sumsqdist(params1.tail,train_vecs,test_vecs,train_ndx,test_ndx,ddim);

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

D = 2;
N = 5;
T = 3;
Q = 4;
ndx = ceil(T.*rand(1,N));
scores = randn(D,N);
train = randn(Q,T);
test = randn(Q,T);

ddim = 2;
ssat = 0.99;
[fusion,params] = quality_fuser_v3([],scores,train,test,ndx,ndx,ddim);

w0 = params.get_w0(ssat);
test_MV2DF(fusion,w0);


quality_fuser_v3(w0,scores,train,test,ndx,ndx,ddim),

end
