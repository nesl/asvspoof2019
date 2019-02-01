function [scores,aux1,aux2,classf] = synth_scores_with_quality(means,H,N)

tar = 1:N/2;
non = tar+N/2;
classf = -ones(1,N);
classf(tar) = 1;


[adim,rdim] = size(H);
r1 = randn(rdim,N);
r2 = randn(rdim,N);
aux1 = H*r1 + randn(adim,N);
aux2 = H*r2 + randn(adim,N);

d1 = sum(r1.^2,1);
d2 = sum(r2.^2,1);


dim = size(means,1);

scores = bsxfun(@times,randn(dim,N),sqrt(d1.*d2));
scores(:,tar) = bsxfun(@plus,scores(:,tar),means(:,1));
scores(:,non) = bsxfun(@plus,scores(:,non),means(:,2));

