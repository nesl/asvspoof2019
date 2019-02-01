function [inv_map,bi_inv_map,logdet,invA] = inv_lu2(A)
% INV_LU2
% Does a LU decomposition on A and returns logdet, inverse and
% two function handles that respectively map X to A\X and A\X/A.
%

if nargin==0
    test_this();
    return;
end

[L,T,p] = lu(A,'vector');
P = sparse(p,1:length(p),1);
                   % P*A = L*U
                   % L is lower triangular, with unit diagonal and unit determinant
                   % T is upper triangular, det(T) = prod(diag(T), may have negative values on diagonal
                   % P is a permuation matrix: P' = inv(P) and det(P) is +1 or -1
                   % 

inv_map = @(X) T\(L\(P*X));

% inv(A)*X*inv(A)
bi_inv_map = @(X) ((inv_map(X)/T)/L)*P;


if nargout>2
    logdet = sum(log(diag(T)))-log(det(P));
    if nargout>3
        invA = T\(L\P);
    end
end

function test_this()
dim = 3;
A = randn(dim)+sqrt(-1)*randn(dim);
[inv_map,bi_inv_map,logdet,iA] = inv_lu2(A);
[logdet,log(det(A))]
X = randn(dim,3);
Y1 = A\X,
Y2 = inv_map(X)

Z1 = (A\X)/A
Z2 = bi_inv_map(X)


iA,
inv(A)
