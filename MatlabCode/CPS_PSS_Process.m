function CPS_PSS_Process
%function CPS_PSS_Process(lambda)
lambda = 25;

T = 1;
N = 5000;
h = T/N;  t = (0:h:T);
I = zeros(N,1);
X = zeros(N+1,1);  X(1) = 0;
for i = 1:N
    I(i) = pssrnd1(h*lambda);
    X(i+1) = X(i) -lambda*h + I(i);
end
plot(t,X)