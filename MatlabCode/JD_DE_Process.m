function JD_DE_Process
%function JD_DE_Process(mu,sigma,lambda,p,eta1,eta2)
tic
mu = 0.5;
sigma = 0.2;
lambda = 0.5;
p = 0.2;
eta1 = 0.25;
eta2 = 0.4;
T = 1;
N = 12;
h = T/N;  
t = (0:h:T);
I = zeros(N,1);
X = zeros(N+1,1);  X(1) = 0;
F = zeros(N+1,1);
for i = 1:N
    I(i) = pssrnd1(h*lambda);
    if I(i) == 0
        F(i) = 0;
    else
        K = binornd(I(i),p);
        R1 = Gamma1(K*eta1,eta2);
        R2 = Gamma1((I(i)-K)*eta1,eta2);
        F(i) = R1 - R2;
    end
    X(i+1) = X(i) + mu*h + sigma*sqrt(h)*randn + F(i);
end
toc
%X = exp(X);    % Exp-Levy model
%plot(t,X)