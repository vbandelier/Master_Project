function Black_Scholes
%function Black_Scholes(r,sigma)
r = 0.05;
sigma = 0.2;
S0 = 100;
T = 1;
mu = r - 0.5*sigma*sigma;
N = 5000;
h = T/N;  t = (0:h:T);
X(1) = 0;
for i=1:N
    X(i+1) = X(i) + mu*h + sigma*sqrt(h)*randn;
end
S = S0*exp(X);
plot(t,S)