function [ J ] = random_DE( N,p,eta1,eta2 )
%random_DE Compute the sum of N double exponential random variable.
K = random('bino', N,p);
Jp= random('gam', K,1/eta1);
Jm= random('gam',(N-K),1/eta2);
J = Jp-Jm;
end

