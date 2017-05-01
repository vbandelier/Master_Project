function [ S,t ] = NIG_generator( S0,r,q,alpha,beta,delta,T,dt,M )
%Merton_GENERATOR Generate M stock price paths under NIG model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   alpha   : tail heaviest of steepness
%   beta    : symmetry
%   delta   : scale
%   T       : maturity
%   dt      : time step
% Outputs :
%   S       : stock price process
%   t       : discret time domain
t = 0:dt:T;
N = T/dt;
a = dt;
b = delta * sqrt(alpha^2-beta^2);
mu = r-q-delta*(sqrt(alpha^2-beta^2)-sqrt(alpha^2-(beta^2-1)));
Tt = random('inversegaussian',a/b,a^2,M,N);
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt + beta*delta^2*Tt + delta*sqrt(Tt).*Z,2)];
S = S0*exp(X);
end