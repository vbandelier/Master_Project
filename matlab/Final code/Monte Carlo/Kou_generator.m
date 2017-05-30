function S = Kou_generator( S0,r,q,T,N,sigma,lambda,p,eta1,eta2,M )
%Merton_GENERATOR Generate M stock price paths under Kou model.
% Inputs :
%   r,q     : domestic and foreign risk free rates
%   sigma   : volatility
%   lambda  : jump intensity
%   p       : probability of a positive jump
%   eta1,eta2 : decay of the tails in the distribution 
%   T       : maturity
%   N       : time discretization
% Outputs :
%   S       : stock price process
%   t       : discret time domain
dt = T/N;
mu = r-q-0.5*sigma^2-lambda*((p*eta1)/(eta1-1)+((1-p)*eta2)/(eta2+1)-1);
Nt = random('poiss',lambda*dt,M,N);
Jumps = arrayfun(@(n) random_DE_2(n,p,eta1,eta2),Nt);
Z = random('norm',0,1,M,N);
X = [zeros(M,1) cumsum(mu*dt+sigma*sqrt(dt)*Z+Jumps,2)];
S = S0*exp(X)';
end

function [ J ] = random_DE_1(N,p,eta1,eta2)
u = random('unif',0,1,N,1);
x = 1/eta2*log(u./(1-p)).*(u < 1-p)+1/eta1*log(p./(1-u)).*(u >= 1-p);
J = sum(x);
end

function [ J ] = random_DE_2( N,p,eta1,eta2 )
%random_DE Compute the sum of N double exponential random variable.
K = random('bino', N,p);
Jp= random('gam', K,1/eta1);
Jm= random('gam',(N-K),1/eta2);
J = Jp-Jm;
end

