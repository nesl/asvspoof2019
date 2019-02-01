function [y,deriv] = calibrateScores(w,m,n)
% This is an MV2DF. See MV2DF_API_DEFINITION.readme.
%
%   [vec(A);scal;offs] --> vec(bsxfun(@plus,scal*A,b))
%
%   This function retrieves from w:
%      (i)   an m-by-n matrix, 'scores'
%      (ii)  a scalar 'scal', and
%      (iii) an m-vector, 'offset'
%
% Then it scales the scores and adds the offset vector to every column. 

if nargin==0
    test_this();
    return;
end

if isempty(w) 
    scoreSz = m*n;
    wSz = scoreSz+m+1;
    at = 1;

    scores = subvec(w,wSz,at,scoreSz);
    at = at + scoreSz;
    
    scal = subvec(w,wSz,at,1);
    at = at + 1;
    
    offs = subvec(w,wSz,at,m);
    
    scores = gemm(stack(w,scores,scal),scoreSz,1,1);
    scores = addOffset(stack(w,scores,offs),m,n);
    y = scores;
    return;
end


if isa(w,'function_handle')
    f = calibrateScores([],m,n);
    y = compose_mv(f,w,[]);
    return;
end


f = calibrateScores([],m,n);
[y,deriv] = f(w);

function test_this()
m = 5;
n = 10;
scores = randn(m,n);
offs = randn(m,1);
scal = 3;

f = calibrateScores([],m,n);
test_MV2DF(f,[scores(:);scal;offs]);
