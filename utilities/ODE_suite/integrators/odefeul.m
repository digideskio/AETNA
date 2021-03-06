% Function to integrate a system of first-order 
% initial-value ODE's by the forward Euler method.
% 
%  [ts, ys] = odefeul (rhsfun, tspan, y0, options, varargin)
%
% The integrator accepts the same arguments as the built-in
% Matlab solvers ode23,�.  The time step needs to be set
% by the options argument, field InitialStep.
% 
% Example:
% [ts, ys] = odefeul (rhsfun, tspan, y0, struct('InitialStep',dt))
%
% One Forward Euler step for the equation dy/dt = f(t,y) is
% 
% y_n+1 = y_n + h * f(t_n, y_n)
%
% Arguments:
%    rhsfun  = right-hand side function: returns f(t,y) 
%              as a column vector.
%    tspan   = time span (start time, usually zero, 
%              and stop time).
%    y0      = initial condition.
%    h       = step size; constant.
%
%
% Copyright (C) 2007-2016, Petr Krysl
% 
function [ts, ys] = odefeul (rhsfun, tspan, y0, options, varargin)
    try,        h=options.(matchfieldname(options, 'InitialStep'));
    catch,      error(['Option InitialStep must be supplied']);    end
    % check whether we are going forward or backward in time
    if (tspan(2)<tspan(1)),h=-abs(h);end
    nsteps = abs(ceil ((tspan(2) - tspan(1)) / h));
    ts = zeros(nsteps+1,1);
    ys = zeros(nsteps+1,length(y0));
    t = tspan(1);
    ts(1) = t;
    ys(1,:) = conj(y0');
    for step = 2:nsteps+1
        if (abs(tspan(2)-ts(step-1))<abs(h)),h=tspan(2)-ts(step-1);end
        ts(step) = ts(step-1) + h;
        ys(step,:) = (feval ('FEuler', rhsfun, h, ts(step-1), ys(step-1,:)', varargin{:}))';
    end
    ys=conj(ys);
    return;
end

%
% Do one Forward Euler step for the equation dy/dt = f(t,y).
% 
% y_n+1 = y_n + h * f(t_n, y_n)
%
% Arguments: 
%   rhsfun = rhs function f(t,y)
%   h      = step length
%   tn     = time t_n
%   yn     = function value y_n
%   
function [yn1] = FEuler (rhsfun, h, tn, yn, varargin)
    yn1 = yn + h * feval (rhsfun, tn, yn, varargin{:});
end
