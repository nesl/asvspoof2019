function [inv_map,logdet] = invchol_taylor(A)
% Does a Cholesky decomposition on A and returns: 
%   inv_map: a function handle to solve for X in AX = B
%   logdet (of A)
%
% This code is designed to work correctly if A has a small complex
% perturbation, such as used in complex step differentiation, even though
% the complex A is not positive definite.


if nargin==0
    test_this();
    return;
end

if isreal(A)

    R = chol(A); %R'*R = A
    inv_map = @(X) R\(R'\X); 

    if nargout>1
        logdet = 2*sum(log(diag(R)));
    end
    if nargout>2
        invA = inv_map(eye(size(A)));
    end
    
else
    R = chol(real(A));
    rmap = @(X) R\(R'\X); 
    P = rmap(imag(A));
    inv_map = @(X) inv_map_complex(X,rmap,P);

    if nargout>1
        logdet = 2*sum(log(diag(R))) + i*trace(P);
    end
end

end

function Y = inv_map_complex(X,rmap,P)
    Z = rmap(X);
    Y = Z - i*P*Z;
end


function test_this()
    
    dim = 20;
    R = randn(dim,dim+1);
    C = R*R';
    C = C + 1.0e-20i*randn(dim);    
    [map,logdet] = invchol_taylor(C);
    
    x = randn(dim,1);
    maps = imag([map(x),C\x]),
    logdets = imag([logdet,log(det(C))])

    maps = real([map(x),C\x]),
    logdets = real([logdet,log(det(C))])
    
    
end
