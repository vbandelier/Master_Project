function [ S,t ] = Merton_generator( S0,r,q,sigma,lambda,alpha,delta,T,dt,M )
%Merton_GENERATOR Generate M stock price paths under Merton model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   sigma   : volatility
%   lambda  : jump intensity
%   alpha   : mean of jump size
%   delta   : standard deviation of jump size
%   T       : maturity
%   dt      : time step
% Outputs :
%   S       : stock price process
%   t       : discret time domain
t = 0:dt:T;
N = T/dt;
mu = r-q-0.5*sigma^2-lambda*(exp(alpha+0.5*delta^2)-1);
Nt = random('poiss',lambda*dt,M,N);
Jumps = arrayfun(@(n) random('norm',n*alpha,n*delta),Nt);
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt+sigma*sqrt(dt)*Z+Jumps,2)];
S = S0*exp(X);
end
