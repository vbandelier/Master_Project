function NIG_Sub_Brown
%function NIG_Sub_Brown(alpha,beta,delta)
alpha = 40;
beta = -8;
delta = 1;
a = 1;
b = delta*sqrt(alpha*alpha - beta*beta);
T = 1; 
N = 1000;
h = T/N;  t = (0:h:T);
I = zeros(N,1);
X = zeros(N+1,1);  X(1) = 0;
for i = 1:N
    I(i) = IG2(a*h,b);
    X(i+1) = X(i) + beta*delta*delta*I(i) + delta*sqrt(I(i))*randn;
end
%X = exp(X);    % Exp-Lévy model
plot(t,X)