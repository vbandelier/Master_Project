function S = VG_generator( S0,r,q,T,N,theta,sigma,nu,M )
%Merton_GENERATOR Generate M stock price paths under VG model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   theta   : drift of the Brownian motion
%   sigma   : volatility of the Brownian motion
%   nu      : variance rate of the time change
%   T       : maturity
%   N       : time discretization
% Outputs :
%   S       : stock price process
%   t       : discret time domain
dt = T/N;
a = dt/nu;
b = nu;
mu = r-q+1/nu*log(1-theta*nu-0.5*sigma^2*nu);
Tt = random('gam',a,b,M,N);
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt + theta*Tt + sigma*sqrt(Tt).*Z,2)];
S = S0*exp(X)';
end