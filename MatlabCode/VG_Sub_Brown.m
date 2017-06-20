function VG_Sub_Brown
%function VG_Sub_Brown(sigma,nu,theta)
sigma = 0.1;
nu = 0.05;
theta = 0.15;

a = 1/nu;
b = 1/nu;
T = 1; 
N = 1000;
h = T/N;  t = (0:h:T);
X = zeros(N+1,1); 
I = zeros(N+1,1);
for i = 1:N
    I(i) = Gamma1(a*h,b);
    X(i+1) = X(i) + theta*I(i) + sigma*sqrt(I(i))*randn;
end
%X = exp(X);    % Exp-Lévy model
plot(t,X)