function [y,deriv] = scale_and_translate(w,vectors,params,m,n)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, obtained by scaling and translating the 
% column vectors of the output matrix of the function vectors(w). The
% scaling and translation parameters, params(w) is also a function of w.
%
% The output, y is calulated as follows:
%
%    V = reshape(vectors(w),m,n);
%    [scal;offs] = params(w); where scal is scalar and offs is m-by-1
%    y = bsxfun(@plus,scal*V,offs);
%    y = y(:);
%
% Usage examples:
%
%     s = @(w) sum_of_functions(w,[1,-1],f,g)
%
% Here f,g are function handles to MV2DF's. 


if nargin==0
    test_this();
    return;
end

if isempty(w) 

    s = stack(w,vectors,params);
    y = calibrateScores(s,m,n);
    return;
end


if isa(w,'function_handle')
    f = scale_and_translate([],vectors,params,m,n);
    y = compose_mv(f,w,[]);
    return;
end


f = scale_and_translate([],vectors,params,m,n);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function test_this()

m = 5;
n = 10;
data = randn(m,n);
offs = randn(m,1);
scal = 3;
w = [data(:);scal;offs];

vectors = subvec([],m*n+m+1,1,m*n);
%vectors = randn(size(data));
params = subvec([],m*n+m+1,m*n+1,m+1);
%params = [scal;offs];

f = scale_and_translate([],vectors,params,m,n);
test_MV2DF(f,w);
