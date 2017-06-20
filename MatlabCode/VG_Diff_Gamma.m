function VG_Diff_Gamma
%function VG_Diff_Gamma(C,G,M)
C = 20;
G = 80;
M = 50;

a1 = C; b1 = M;
a2 = C; b2 = G;
T = 1;
N = 1000;
h = T/N;  t = (0:h:T);
G1 = zeros(N+1,1); G2 = zeros(N+1,1);
VG = zeros(N+1,1);
for i = 1:N
    G1(i+1) = G1(i) + Gamma1(a1*h,b1);
    G2(i+1) = G2(i) + Gamma1(a2*h,b2);
    VG(i+1) = G1(i) - G2(i);
end
%VG = exp(VG);    % Exp-Lévy model
plot(t,VG)