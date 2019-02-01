function f = duplicator_fh(duplication_indices,xdim,w)
%
% This factory creates a function handle to an MV2DF, which represents the
% function:
%
%    y = x(duplication_indices)
%

if nargin==0
    test_this();
    return;
end


map = @(x) x(duplication_indices);

%xdim = max(duplication_indices);
ydim = length(duplication_indices);
c = zeros(1,ydim);
r = zeros(1,ydim);
at = 1;
for i=1:xdim
    ci = find(duplication_indices==i);
    n = length(ci);
    r(at:at+n-1) = i;
    c(at:at+n-1) = ci;
    at = at + n;
end
reverse = sparse(r,c,1,xdim,ydim);

transmap = @(y) reverse*y;

f = @(w) linTrans(w,map,transmap);

if exist('w','var') && ~isempty(w)
    f = f(w);
end

end

function test_this()

dup = [ 1 3 1 3];
x = [ 1 2 3 4];

f = duplicator_fh(dup,length(x));

y = f(x),


test_MV2DF(f,x);


end
