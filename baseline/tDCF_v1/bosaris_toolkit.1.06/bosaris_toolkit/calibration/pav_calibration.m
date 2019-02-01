function [pav_trans,score_bounds,llr_bounds] = pav_calibration(tar,non,small_val)
% Creates a calibration transformation function using the PAV algorithm.
% Inputs:
%   tar: A vector of target scores.
%   non: A vector of non-target scores.
%   small_val: An offset to make the transformation function
%     invertible.  small_val is subtracted from the left-hand side
%     of the bin and added to the right-hand side (and the bin
%     height is linear between its left and right ends).
% Outputs:
%   pav_trans: The transformation function.  It takes in scores and
%     outputs (calibrated) log-likelihood ratios.
%   score_bounds: The left and right ends of the line segments
%     that make up the transformation.
%   llr_bounds: The lower and upper ends of the line segments that
%     make up the transformation.

if nargin==0
    test_this()
    return
else
    assert(nargin==3)
    assert(size(tar,1)==1)
    assert(size(non,1)==1)
    assert(length(tar)>0)
    assert(length(non)>0)
end

largeval = 1e6;

scores = [-largeval tar non largeval];
Pideal = [ones(1,length(tar)+1),zeros(1,length(non)+1)];
[scores,perturb] = sort(scores);
Pideal = Pideal(perturb);
[Popt,width,height] = pavx(Pideal);
data_prior = (length(tar)+1)/length(Pideal);
llr = logit(Popt) - logit(data_prior);
bnd_ndx = make_bnd_ndx(width);
score_bounds = scores(bnd_ndx);
llr_bounds = llr(bnd_ndx);
llr_bounds(1:2:end) = llr_bounds(1:2:end) - small_val;
llr_bounds(2:2:end) = llr_bounds(2:2:end) + small_val;
pav_trans = @(s) pav_transform(s,score_bounds,llr_bounds);
end

function scr_out = pav_transform(scr_in,score_bounds,llr_bounds)
scr_out = zeros(1,length(scr_in));
for ii=1:length(scr_in)
    x = scr_in(ii);
    [x1,x2,v1,v2] = get_line_segment_vals(x,score_bounds,llr_bounds);
    scr_out(ii) = (v2 - v1) * (x - x1) / (x2 - x1) + v1;
end
end

function bnd_ndx = make_bnd_ndx(width)
len = length(width)*2;
c = cumsum(width);
bnd_ndx = zeros(1,len);
bnd_ndx(1:2:len) = [1 c(1:end-1)+1];
bnd_ndx(2:2:len) = c;
end

function [x1,x2,v1,v2] = get_line_segment_vals(x,score_bounds,llr_bounds)
p = find(x>=score_bounds,1,'last');
x1 = score_bounds(p);
x2 = score_bounds(p+1);
v1 = llr_bounds(p);
v2 = llr_bounds(p+1);
end

function test_this()
ntar = 10;
nnon = 12;
tar = 2*randn(1,ntar)+2;
non = 2*randn(1,nnon)-2;
tarnon = [tar non];

scores = [-inf tarnon inf];
Pideal = [ones(1,length(tar)+1),zeros(1,length(non)+1)];
[scores,perturb] = sort(scores);
Pideal = Pideal(perturb);
[Popt,width,height] = pavx(Pideal);
data_prior = (length(tar)+1)/length(Pideal);
llr = logit(Popt) - logit(data_prior);
[dummy,pinv] = sort(perturb);
tmp = llr(pinv);
llr = tmp(2:end-1)

pav_trans = pav_calibration(tar,non,0);
pav_trans(tarnon)

end
