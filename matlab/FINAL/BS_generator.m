function [ S,t ] = BS_generator( S0,r,q,sigma,T,dt,M )
%BS_GENERATOR Generate M stock price paths under BS model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   sigma   : volatility
%   T       : maturity
%   dt      : time step
% Outputs :
%   S       : stock price process
%   t       : discret time domain
t = 0:dt:T;
N = T/dt;
mu = r-q-0.5*sigma^2;
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt+sigma*sqrt(dt)*Z,2)];
S = S0*exp(X);
end

