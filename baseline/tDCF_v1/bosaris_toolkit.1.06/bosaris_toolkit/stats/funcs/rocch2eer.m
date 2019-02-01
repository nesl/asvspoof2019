function eer = rocch2eer(pmiss,pfa)
% Calculates the equal error rate (eer) from pmiss and pfa
% vectors.  
% Note: pmiss and pfa contain the coordinates of the vertices of the
%       ROC Convex Hull.  
% Use rocch.m to convert target and non-target scores to pmiss and
% pfa values.

assert(isvector(pmiss))
assert(isvector(pfa))

x = [];
y = [];
eer = 0;
for i=1:length(pfa)-1
    xx = pfa(i:i+1);
    yy = pmiss(i:i+1);

    %xx and yy should be sorted:
    assert(xx(2)<=xx(1)&&yy(1)<=yy(2));
    
    XY = [xx(:),yy(:)];
    dd = [1,-1]*XY;
    if min(abs(dd))==0
	eerseg = 0;
    else 
	%find line coefficieents seg s.t. seg'[xx(i);yy(i)] = 1, 
	%when xx(i),yy(i) is on the line.
	seg = XY\[1;1];
	eerseg = 1/(sum(seg)); %candidate for EER, eer is highest candidate
    end  
    
    eer = max(eer,eerseg);
end
