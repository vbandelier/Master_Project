function [ S,t ] = Kou_generator( S0,r,q,sigma,lambda,p,eta1,eta2,T,dt,M )
%Merton_GENERATOR Generate M stock price paths under Kou model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   sigma   : volatility
%   lambda  : jump intensity
%   p       : probability of a positive jump
%   eta1,eta2 : decay of the tails in the distribution 
%   T       : maturity
%   dt      : time step
% Outputs :
%   S       : stock price process
%   t       : discret time domain
t = 0:dt:T;
N = T/dt;
mu = r-q-0.5*sigma^2-lambda*((p*eta1)/(eta1+1)+((1-p)*eta2)/(eta2+1)-1);
Nt = random('poiss',lambda*dt,M,N);
Jumps = arrayfun(@(n) random_DE(n,p,eta1,eta2),Nt);
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt+sigma*sqrt(dt)*Z+Jumps,2)];
S = S0*exp(X);
end
