function [z,mz,onrim,Hd_record] = cg_steihaug(grad,hess,Delta,epsilon,maxCG,y,Hd_back,quiet)
% Helper function for trustregion_newton_cg

savemem = true;

grad = grad(:);
onrim = false;
if exist('Hd_back','var') && ~isempty(Hd_back)
    Hd_record = Hd_back;
    backtrack = true;
else
    backtrack = false;
    if savemem
        Hd_record = zeros(length(grad),maxCG,'single');
    else
        Hd_record = zeros(length(grad),maxCG);
    end
end

z = zeros(size(grad));  % z is step, we start at origin
mz = 0;                 % 2nd order prediction for objective change at step z 
r = grad;               % 2nd order residual at z:  r = H*z-grad
d = -r;                 % we're going down

residual = sqrt(r'*r)/epsilon;
if residual <= 1
    Hd_record = [];
    fprintf('CG 0: as far as I can see, this should never happen\n');
    fprintf('CG 0: converged with zero step, residual = %g\n',residual);
    return
end

j=0;
while true
    if backtrack && j+1 <= size(Hd_back,2)
        Hd = double(Hd_back(:,j+1));
    else
        Hd = hess(d);
        if j+1 <= size(Hd_record)
            Hd_record(:,j+1) = Hd;
        end
    end
    dHd = d'*Hd;
    if dHd <=0 %region is non-convex in direction d
        a = d'*d;
        b = 2*z'*d;
        c = z'*z-Delta^2;
        discr = sqrt(b^2-4*a*c);
        tau1 = (-b - discr)/(2*a);
        tau2 = (-b + discr)/(2*a);
        model = @(tau) tau*grad'*d + 0.5*tau^2*dHd;
        if model(tau1) < model(tau2)
            tau = tau1;
        else
            tau = tau2;
        end
        z = z + tau*d;
        mz = mz + tau*d'*grad + 0.5*tau^2*dHd;
        onrim = true;
        if ~quiet, fprintf('CG %i: curv=%g, jump to trust region boundary\n',j,dHd); end
        break;
    end
    
    alpha = r'*r/dHd;
    old_z = z;
    old_mz = mz;
    z = z + alpha*d;
    mz = mz + alpha*d'*grad + 0.5*alpha^2*dHd;

    
    radius = sqrt(z'*z)/Delta;
    if radius > 1
        a = d'*d;
        b = 2*z'*d;
        c = old_z'*old_z-Delta^2;
        discr = sqrt(b^2-4*a*c);
        tau = (-b + discr)/(2*a);
        z = old_z + tau*d;
        mz = old_mz + tau*d'*grad + 0.5*tau^2*dHd;
        onrim = true;
        if ~quiet, fprintf('CG %i: curv=%g, terminate on trust region boundary, model=%g\n',j,dHd,-mz); end
        break;
    end

    old_r = r;
    r = r + alpha*Hd;
    residual = sqrt(r'*r)/epsilon;
    if residual <= 1 
        if ~quiet, 
            fprintf('CG %i: curv=%G, converged inside trust region; radius = %g, residual=%g, model=%g\n',j,dHd,radius,residual,-mz); 
        end
        break;
    end
    
    overshot = ~isempty(y) && y+mz <0;
    if overshot 
        if ~quiet, 
            fprintf('CG %i: curv=%G, overshot inside trust region; radius = %g, residual=%g, model=%g\n',j,dHd,radius,residual,-mz);
        end
        break;
    end
    
    %stopped = backtrack && j+1 >= maxCG;
    stopped = j+1 >= maxCG;
    if stopped 
        if ~quiet, 
            fprintf('CG %i: curv=%G, stopped inside trust region; radius = %g, residual=%g, model=%g\n',j,dHd,radius,residual,-mz);
        end
        break;
    end
    
    
    
    
    beta = (r'*r)/(old_r'*old_r);
    d = -r + beta*d;
    if ~quiet, fprintf('CG %i: curv=%g, radius = %g, residual=%g, model=%g\n',j,dHd,radius,residual,-mz); end
    j = j+1;
end


if j+1<size(Hd_record,2)
    Hd_record = Hd_record(:,1:j+1);
end
return
