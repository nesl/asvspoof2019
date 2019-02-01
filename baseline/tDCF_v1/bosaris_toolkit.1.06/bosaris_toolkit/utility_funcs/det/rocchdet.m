function [x,y,eer,mindcf] = rocchdet(tar,non,dcfweights,pfa_min,pfa_max,pmiss_min,pmiss_max,dps)
% ROCCHDET: Computes ROC Convex Hull and then maps that to the DET axes.
%
%  (For demo, type 'rocchdet' on command line.)
%
% Inputs:
%
%     tar: vector of target scores
%     non: vector of non-target scores
%
%     dcfweights: 2-vector, such that: DCF = [pmiss,pfa]*dcfweights(:).
%                (Optional, provide only if mindcf is desired, otherwise 
%                 omit or use [].) 
%
%     pfa_min,pfa_max,pmiss_min,pmiss_max: limits of DET-curve rectangle.
%       The DET-curve is infinite, non-trivial limits (away from 0 and 1) 
%       are mandatory.
%       (Uses min = 0.0005 and max = 0.5 if omitted.)
%
%     dps: number of returned (x,y) dots (arranged in a curve) in DET space, 
%          for every straight line-segment (edge) of the ROC Convex Hull.
%          (Uses dps = 100 if omitted.)
%          
% Outputs:
%
%    x: probit(Pfa)
%    y: probit(Pmiss)
%    eer: ROCCH EER = max_p mindcf(dcfweights=[p,1-p]), which is also 
%         equal to the intersection of the ROCCH with the line pfa = pmiss.
%         
%    mindcf: Identical to result using traditional ROC, but
%            computed by mimimizing over the ROCCH vertices, rather than 
%            over all the ROC points.

if nargin==0
    test_this();
    return
end

assert(isvector(tar))
assert(isvector(non))

if ~exist('pmiss_max','var') || isempty(pmiss_max)
    pfa_min = 0.0005;
    pfa_max = 0.5;
    pmiss_min = 0.0005;
    pmiss_max = 0.5;
end

if ~exist('dps','var') || isempty(dps)
    dps = 100;
end


assert(pfa_min>0 && pfa_max<1 && pmiss_min>0 && pmiss_max<1,'limits must be strictly inside (0,1)');
assert(pfa_min<pfa_max && pmiss_min < pmiss_max);

[pmiss,pfa] = rocch(tar,non);

if nargout>3
    dcf = dcfweights(:)'*[pmiss(:)';pfa(:)'];
    mindcf = min(dcf);
end

%pfa is decreasing
%pmiss is increasing


box.left = pfa_min;
box.right = pfa_max;
box.top = pmiss_max;
box.bottom = pmiss_min;

x = [];
y = [];
eer = 0;
for i=1:length(pfa)-1
    xx = pfa(i:i+1);
    yy = pmiss(i:i+1);
    [xdots,ydots,eerseg] = plotseg(xx,yy,box,dps);
    x = [x,xdots];
    y = [y,ydots];
    eer = max(eer,eerseg);
end

end


function [x,y,eer] = plotseg(xx,yy,box,dps)
    
%xx and yy should be sorted:
assert(xx(2)<=xx(1)&&yy(1)<=yy(2));

XY = [xx(:),yy(:)];
dd = [1,-1]*XY;
if min(abs(dd))==0
    eer = 0;
else 
    %find line coefficieents seg s.t. seg'[xx(i);yy(i)] = 1, 
    %when xx(i),yy(i) is on the line.
    seg = XY\[1;1];
    eer = 1/(sum(seg)); %candidate for EER, eer is highest candidate
end

%segment completely outside of box
if xx(1)<box.left || xx(2)>box.right || yy(2)<box.bottom || yy(1)>box.top
    x = [];
    y = [];
    return
end

if xx(2)<box.left
    xx(2) = box.left;
    yy(2) = (1-seg(1)*box.left)/seg(2);
end
if xx(1)>box.right
    xx(1) = box.right;
    yy(1) = (1-seg(1)*box.right)/seg(2);
end
if yy(1)<box.bottom
    yy(1) = box.bottom;
    xx(1) = (1-seg(2)*box.bottom)/seg(1);
end
if yy(2)>box.top
    yy(2) = box.top;
    xx(2) = (1-seg(2)*box.top)/seg(1);
end
dx = xx(2)-xx(1); 
xdots = xx(1)+dx*(0:dps)/dps;
ydots = (1-seg(1)*xdots)/seg(2);
x = probit(xdots);
y = probit(ydots);
end



function test_this

subplot(2,3,1);
hold on;
make_det_axes();

tar = randn(1,100)+2;
non = randn(1,100);
[x,y,eer] = rocchdet(tar,non);
[pmiss,pfa] = compute_roc(tar,non);
plot(x,y,'g',probit(pfa),probit(pmiss),'r');
legend(sprintf('ROCCH-DET (EER = %3.1f%%)',eer*100),'classical DET',...
       'Location','SouthWest');
title('EER read off ROCCH-DET');

   
subplot(2,3,2);
show_eer(pmiss,pfa,eer);

subplot(2,3,3);
[pmiss,pfa] = rocch(tar,non);
show_eer(pmiss,pfa,eer);
   

subplot(2,3,4);
hold on;
make_det_axes();

tar = randn(1,100)*2+3;
non = randn(1,100);
[x,y,eer] = rocchdet(tar,non);
[pmiss,pfa] = compute_roc(tar,non);
plot(x,y,'b',probit(pfa),probit(pmiss),'k');
legend(sprintf('ROCCH-DET (EER = %3.1f%%)',eer*100),'classical DET',...
       'Location','SouthWest');
title('EER read off ROCCH-DET');
   
   
subplot(2,3,5);
show_eer(pmiss,pfa,eer);

subplot(2,3,6);
[pmiss,pfa] = rocch(tar,non);
show_eer(pmiss,pfa,eer);

end


function show_eer(pmiss,pfa,eer)
p = 0:0.001:1;
x = p;
y = zeros(size(p));
for i=1:length(p);
    %y(i) = mincdet @ ptar = p(i), cmiss = cfa = 1  
    y(i) = min(p(i)*pmiss+(1-p(i))*pfa);  
end
plot([min(x),max(x)],[eer,eer],x,y);
grid;
legend('EER','minDCF(P_{tar},C_{miss}=C_{fa}=1)','Location','South');
xlabel('P_{tar}');
title('EER via minDCF on classical DET');
end


function make_det_axes()
%  make_det_axes creates a plot for displaying detection performance
%  with the axes scaled and labeled so that a normal Gaussian
%  distribution will plot as a straight line.
%
%    The y axis represents the miss probability.
%    The x axis represents the false alarm probability.
%
%  Creates a new figure, switches hold on, embellishes and returns handle.

pROC_limits = [0.0005 0.5];

pticks = [0.001 0.002 0.005 0.01 0.02 0.05 0.1 0.2 0.3 0.4];
ticklabels = ['0.1';'0.2';'0.5';' 1 ';' 2 ';' 5 ';'10 ';'20 ';'30 ';'40 '];

axis('square');

set (gca, 'xlim', probit(pROC_limits));
set (gca, 'xtick', probit(pticks));
set (gca, 'xticklabel', ticklabels);
set (gca, 'xgrid', 'on');
xlabel ('False Alarm probability (in %)');


set (gca, 'ylim', probit(pROC_limits));
set (gca, 'ytick', probit(pticks));
set (gca, 'yticklabel', ticklabels);
set (gca, 'ygrid', 'on')
ylabel ('Miss probability (in %)')

end
