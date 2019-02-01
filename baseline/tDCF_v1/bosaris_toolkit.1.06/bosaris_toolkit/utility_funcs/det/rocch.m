function [pmiss,pfa] = rocch(tar_scores,nontar_scores)
% ROCCH: ROC Convex Hull.
% Usage: [pmiss,pfa] = rocch(tar_scores,nontar_scores)
% (This function has the same interface as compute_roc.)
%
% Note: pmiss and pfa contain the coordinates of the vertices of the
%       ROC Convex Hull.
%
% For a demonstration that plots ROCCH against ROC for a few cases, just
% type 'rocch' at the MATLAB command line.
%
% Inputs:
%   tar_scores: scores for target trials
%   nontar_scores: scores for non-target trials

if nargin==0
    test_this();
    return
end

assert(nargin==2)
assert(isvector(tar_scores))
assert(isvector(nontar_scores))

Nt = length(tar_scores);
Nn = length(nontar_scores);
N = Nt+Nn;
scores = [tar_scores(:)',nontar_scores(:)'];
Pideal = [ones(1,Nt),zeros(1,Nn)];  %ideal, but non-monotonic posterior

%It is important here that scores that are the same (i.e. already in order) should NOT be swapped.
%MATLAB's sort algorithm has this property.
[scores,perturb] = sort(scores);

Pideal = Pideal(perturb);
[Popt,width] = pavx(Pideal); 

nbins = length(width);
pmiss = zeros(1,nbins+1);
pfa = zeros(1,nbins+1);

%threshold leftmost: accept eveything, miss nothing
left = 0; %0 scores to left of threshold
fa = Nn;
miss = 0;

for i=1:nbins
    pmiss(i) = miss/Nt;
    pfa(i) = fa/Nn;
    left = left + width(i);
    miss = sum(Pideal(1:left));
    fa = N - left - sum(Pideal(left+1:end));
end
pmiss(nbins+1) = miss/Nt;
pfa(nbins+1) = fa/Nn;

end


function test_this()

figure();

subplot(2,3,1);
tar = [1]; non = [0];
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g--v');
axis('square');grid;legend('ROCCH','ROC');
title('2 scores: non < tar');

subplot(2,3,2);
tar = [0]; non = [1];
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g-v');
axis('square');grid;
title('2 scores: tar < non');

subplot(2,3,3);
tar = [0]; non = [-1,1];
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g--v');
axis('square');grid;
title('3 scores: non < tar < non');

subplot(2,3,4);
tar = [-1,1]; non = [0];
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g--v');
axis('square');grid;
title('3 scores: tar < non < tar');
xlabel('P_{fa}');
ylabel('P_{miss}');

subplot(2,3,5);
tar = randn(1,100)+1; non = randn(1,100);
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g');
axis('square');grid;
title('45^{\circ} DET');

subplot(2,3,6);
tar = randn(1,100)*2+1; non = randn(1,100);
[pmiss,pfa] = rocch(tar,non);
[pm,pf] = compute_roc(tar,non);
plot(pfa,pmiss,'r-^',pf,pm,'g');
axis('square');grid;
title('flatter DET');

end
