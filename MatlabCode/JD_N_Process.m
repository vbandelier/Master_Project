function JD_N_Process
%function JD_N_Process(mu,sigma,lambda,A,B)
mu = 2;
sigma = 1;
lambda = 10;
A = -0.05;
B = 0.2;
T = 1;
N = 5000;
h = T/N;  t = (0:h:T);
I = zeros(N,1);
X = zeros(N+1,1);  X(1) = 100;
F = zeros(N+1,1);
for i = 1:N
    I(i) = pssrnd1(h*lambda);
    if I(i) == 0
        F(i) = 0;
    else
        F(i) = A*I(i) + sqrt(B)*sqrt(I(i))*randn;
    end
    X(i+1) = X(i) + mu*h + sigma*sqrt(h)*randn + F(i);
end
X = exp(X);    % Exp-Levy model
plot(t,X)