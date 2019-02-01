function [w,y,state,converged] = trustregion_newton_cg(f,w,maxiters,maxCG,state,eta,nonnegative_f,quiet)
%
% Trust Region Newton Conjugate Gradient (TRNCG): 
%   --- Algorithm for Large-scale Unconstrained Minimization  ---
%
% Inputs:
%    f: the objective function, which maps R^n to R.
%       this function must implement the MV2DF interface in order to privde
%       1st and 2nd order derivatives to the optimizer.
%
%    w: the optimization starting point in R^n
%    maxiters: the maximum number of outer (Newton) iterations
%    maxCG: (optional, default = 100) the maximum number of inner (conjugate gradient) iterations per
%           outer iteration. In some cases CG eats memory. Reducing maxCG can be
%           used to control memory consumption at the expense of possibly
%           slower convergence. (However, in some cases, reducing maxCG may also in fact speed
%           convergence by avoiding fruitless CG iterations.)
%    state: (optional) if iteration is resumed this must be state as returned by previous
%           iteration. If not given state is recomputed (although it may not be equivalent).
%    eta:   (optional, default eta = 1e-4). Threshold for accepting iteration. Iteration is
%                      rejected (and backtracking is done), if rho < eta.
%                      rho is goodness of quadratic model prediction of
%                      decrease in objective value. 
%                      Perfect prediction gives rho = 1. Increase gives
%                      rho<0. Decrease better than model gives rho>1.
%                      Legal values: 0 <= eta < 0.25. 
%    nonnegative_f: (optional, default = false) flag to assert that f>=0.
%                   If true, CG iteration can be interrupted if quadratic
%                   model prediction goes below zero.
%    quiet: (optional, default = false) If true, does not output iteration 
%           information to screen.



converged = false;

if ~exist('nonnegative_f','var') || isempty(nonnegative_f)
    nonnegative_f = false;
end

if ~exist('quiet','var') || isempty(nonnegative_f)
    quiet = false;
end


if ~exist('maxCG','var') || isempty(maxCG)
    maxCG = 100;
end


if ~exist('eta','var') || isempty(eta)
    eta = 1e-4; % Lin
elseif eta>=0.25 || eta<0
    error('illegal eta');
end

if exist('state','var') && ~isempty(state)
    y = state.y;
    g = state.g;
    hess = state.hess;
    Delta = state.Delta;
else
    [y,deriv] = f(w);
    [g,hess] = deriv(1);
    Delta = sqrt(g'*g); %lin
end

if ~quiet, fprintf('TR 0 (initial state): obj = %g, Delta = %g\n\n',y,Delta); end

DeltaMax = inf;


Hd = [];
iter = 1;
while iter <= maxiters

    gmag = sqrt(g'*g);
    if gmag ==0 
        if ~quiet, fprintf('TR %i: converged with zero gradient\n',iter); end
        converged = true;
        state = [];
        break;
    end
    %epsilon = min(0.5,sqrt(gmag))*gmag; %Nocedal
    epsilon = 0.1*gmag; %Lin

    if nonnegative_f
        ycheck = y;
    else
        ycheck = [];
    end
    [z,mz,onrim,Hd] = cg_steihaug(g,hess,Delta,epsilon,maxCG,ycheck,Hd,quiet);
    
    %fprintf('paused');
    %pause;
    %fprintf('\n');
    
    % sanity check on delta_m --- looks good
    %check_m = -z'*g - 0.5*z'*hess(z);
    %[check_m,-mz]
    
    if z'*z == 0 
        if ~quiet, fprintf('TR %i: converged with zero step\n',iter); end
        converged = true;
        state = [];
        break;
    end
    
    w_new = w + z;
    [y_new,deriv_new] = f(w_new);
    

    
    
    if nonnegative_f && y_new == 0
        if ~quiet, fprintf('TR %i: converged with zero objective\n',iter); end
        converged = true;
        w = w_new;
        state = [];
        break;
    end
    
    
    rho = (y_new - y)/mz;

    
    if abs(mz) < sqrt(eps) && rho>0.75 && onrim==false 
        if ~quiet, fprintf('TR %i: converged with minimal model change\n',iter); end
        converged = true;
        state = [];
        break;
    end
    
    
    
    if rho<0.25
        Delta = Delta/4;
        if ~quiet, fprintf('contracting: Delta=%g\n',Delta); end
    elseif rho > 0.75 && onrim
        Delta = min(2*Delta,DeltaMax);
        if ~quiet, fprintf('expanding: Delta=%g\n',Delta); end
    end
    
    if rho>eta
        if ~quiet, fprintf('TR %i: obj=%g; rho=%g\n\n',iter,y_new,rho); end
        w = w_new;
        y = y_new;
        deriv = deriv_new;
        [g,hess] = deriv(1);
        Hd = [];
        iter = iter+1;
    else
        if ~quiet, fprintf('TR %i: obj=%g; backtracking; rho=%g\n\n',iter,y,rho); end
    end
            
end

state.Delta = Delta;
state.y = y;
state.g = g;
state.hess = hess;
