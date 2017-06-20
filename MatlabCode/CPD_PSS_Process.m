function CPD_PSS_Process
%function CPD_PSS_Process(lambda)
lambda = 25;

T = 1;
N = 5000;
h = T/N;  t = (0:h:T);
I = zeros(N,1);
X = zeros(N+1,1);  X(1) = 0;
F = zeros(N+1,1);
for i = 1:N
    I(i) = pssrnd1(h*lambda);
    if I(i) == 0;
        F(i) = 0;
    else F(i) = randn;
    end
    X(i+1) = X(i) + F(i);
end
plot(t,X)