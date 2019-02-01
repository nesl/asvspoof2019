function fh = AWB_sparse(qual,ndx,w)
% Produces trial quality measures from segment quality measures
% using the weighting matrix 'w'.
% This is almost an MV2DF, but it does not return derivatives on numeric
% input, w.
%
% Algorithm: Y = A*reshape(w,..)*B
% Inputs:
%   qual: A Quality object containing quality measures in modelQ
%     and segQ fields.
%   ndx: A Key or Ndx object indicating trials.
%   w: The combination weights for making trial quality measures.
% Outputs:
%   fh: If 'w' is given, vector of quality scores --- one for each
%     trial.  If 'w' is empty, a function handle that produces
%     these scores given a 'w'.

if nargin==0
    test_this();
    return
end

assert(isa(qual,'Quality'))
assert(isa(ndx,'Ndx')||isa(ndx,'Key'))

[q,m] = size(qual.modelQ);
[q1,n] = size(qual.segQ);
assert(q==q1);
if isa(ndx,'Ndx')                     
    trials = ndx.trialmask;
else
    trials = ndx.tar | ndx.non;
end
ftrials = find(trials(:));
k = length(ftrials);
assert(m==size(trials,1)&n==size(trials,2));
[ii,jj] = ind2sub([m,n],ftrials);

    function y = map_this(w) 
        WR = reshape(w,q,q)*qual.segQ;
        y = zeros(1,k);
        done = 0;
        for j=1:n
            right = WR(:,j);
            col = right.'*qual.modelQ(:,trials(:,j));
            len = length(col);
            y(done+1:done+len) = col;
            done = done + len;
        end
        assert(done==k);
    end

    function w = transmap_this(y)
        Y = sparse(ii,jj,y,m,n);
        w = qual.modelQ*Y*qual.segQ.';
    end


map = @(y) map_this(y);
transmap = @(y) transmap_this(y);


fh = linTrans([],map,transmap);

if exist('w','var') && ~isempty(w)
    fh = fh(w);
end


end

function test_this()
m = 3;
n = 4;
q = 2;
qual = Quality();
qual.modelQ = randn(q,m);
qual.segQ = randn(q,n);
ndx = Ndx();
ndx.trialmask = false(m,n);
ndx.trialmask(1,1:2) = true;
ndx.trialmask(2:3,3:4) = true;
ndx.trialmask
f = AWB_sparse(qual,ndx);

w = randn(q*q,1);
test_MV2DF(f,w);

W = reshape(w,q,q)
AWB = qual.modelQ'*W*qual.segQ
[f(w),AWB(ndx.trialmask(:))]

end
