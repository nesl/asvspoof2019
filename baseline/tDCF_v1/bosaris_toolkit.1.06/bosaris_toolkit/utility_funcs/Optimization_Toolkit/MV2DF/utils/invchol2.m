function [inv_map,bi_inv_map,logdet,invA] = invchol2(A)
% INVCHOL2
% Does a Cholesky decomposition on A and returns logdet, inverse and
% two function handles that respectively map X to A\X and A\X/A.
%

if nargin==0
    test_this();
    return;
end

if isreal(A)

    R = chol(A); %R'*R = A
    inv_map = @(X) R\(R'\X); 

    % inv(A)*X*inv(A)
    bi_inv_map = @(X) (inv_map(X)/R)/(R');


    if nargout>2
        logdet = 2*sum(log(diag(R)));
        if nargout>3
            invA = inv_map(eye(size(A)));
        end
    end
else
    inv_map = @(X) A\X; 

    % inv(A)*X*inv(A)
    bi_inv_map = @(X) (A\X)/A;


    if nargout>2
        logdet = log(det(A));
        if nargout>3
            invA = inv_map(eye(size(A)));
        end
    end
end

function test_this()
dim = 3;
r = randn(dim,2*dim);
A = r*r';
[inv_map,bi_inv_map,logdet,iA] = invchol2(A);
[logdet,log(det(A))]
X = randn(dim,3);
Y1 = A\X,
Y2 = inv_map(X)

Z1 = (A\X)/A
Z2 = bi_inv_map(X)


iA,
inv(A)
