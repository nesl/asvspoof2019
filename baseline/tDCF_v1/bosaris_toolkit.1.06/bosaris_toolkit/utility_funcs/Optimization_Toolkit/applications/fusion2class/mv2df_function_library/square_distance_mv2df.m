function [y,deriv] = square_distance_mv2df(w,input_data,new_dim)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
% The function computes the square distance of the vectors for each trial.
%   y.' = sum((W(:,1:end-1).'*input_data + W(:,end)).^2,1)
%
%      W is the augmented matrix [M c] where M maps a score vector
%      to a lower dimensional space and c is an offset vector in
%      the lower dimensional space.
%
% Parameters:
%     w: the vectorized version of the W matrix
%     input_data: is an M-by-T matrix of input vectors of length M, for each of T
%             trials.
%     new_dim: the dimension of vectors in the lower dimensional space.
%

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    [dim, num_trials] = size(input_data);
    map = @(w) map_this(w,input_data,dim,new_dim);
    transmap = @(w) transmap_this(w,input_data,num_trials,new_dim);
    delta = linTrans(w,map,transmap);
    y = sums_of_squares(delta,new_dim);
    return;
end

if isa(w,'function_handle')
    f = square_distance_mv2df([],input_data,new_dim);
    y = compose_mv(f,w,[]);
    return;
end

f = square_distance_mv2df([],input_data,new_dim);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end




function y = map_this(w,input_data,dim,new_dim)
% V = [input_data; ones(1,num_trials)];
W = reshape(w,new_dim,dim+1);
y = bsxfun(@minus,W(:,1:end-1)*input_data,W(:,end));
y = y(:);

function dx = transmap_this(dy,input_data,num_trials,new_dim)
dY = reshape(dy,new_dim,num_trials);
% V = [input_data; ones(1,num_trials)];
% Vt = V.';
% dX = dY*Vt;
dYt = dY.';
dYtSum = sum(dYt,1);
dX = [input_data*dYt;-dYtSum].';
dx = dX(:);


function test_this()
K = 5;
N = 10;
P = 3;
M = randn(P,N);
c = randn(P,1);
W = [M c];
w = W(:);
input_data = randn(N,K);

f = square_distance_mv2df([],input_data,P);
test_MV2DF(f,w);
