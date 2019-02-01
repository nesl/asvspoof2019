function [y,deriv] = sum_of_functions(w,weights,f,g)
% This is an MV2DF (see MV2DF_API_DEFINITION.readme) which 
% represents the new function, s(w), obtained by summing the 
% weighted outputs of the given functions:
%  s(w) = sum_i weights(i)*functions{i}(w)
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

weights = weights(:);

if isempty(w) 

    s = stack(w,f,g,true);
    n = length(weights);

    map = @(s) reshape(s,[],n)*weights; 
    transmap = @(y) reshape(y(:)*weights.',[],1);

    y = linTrans(s,map,transmap);
    return;
end


if isa(w,'function_handle')
    f = sum_of_functions([],weights,f,g);
    y = compose_mv(f,w,[]);
    return;
end


f = sum_of_functions([],weights,f,g);
if nargout==1
    y = f(w);
else
    [y,deriv] = f(w);
end


function test_this()

A = randn(4,4);
B = randn(4,4);


w = [];
f = gemm(w,4,4,4);
g = transpose_mv2df(f,4,4);

%f = A*B;
%g = B'*A';

s = sum_of_functions(w,[-1,1],f,g);
%s = stack(w,f,g);

test_MV2DF(s,[A(:);B(:)]);
