function Gamma_Process
%function Gamma_process(a,b)
a = 25;
b = 10;

T = 1;
N = 1000;
h = T/N;  t = (0:h:T);
g = zeros(N+1,1);
G = zeros(N+1,1);  G(1) = 0;
for i = 1:N
    g(i) = Gamma1(a*h,b);
    G(i+1) = G(i) + g(i);
end
plot(t,G)