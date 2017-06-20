function Brownian_Motion
%function Brownian_Motion(mu,sigma)
mu = 0.05;
sigma = 0.3;
T = 1;
N = 5000;
h = T/N;  t = (0:h:T);
X(1) = 0;
for i=1:N
    X(i+1) = X(i) + mu*h + sigma*sqrt(h)*randn;
end
plot(t,X)