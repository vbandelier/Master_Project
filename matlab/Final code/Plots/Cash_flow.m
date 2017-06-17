clear

S0 = 1;
K = 1;
Targ = 0.5;
Na = 1000;
Nx = 1000;
A = linspace(0,Targ,Na);
Xmin = -5;
Xmax = 2;
dx = (Xmax-Xmin)/Nx;
x = Xmin + (0:Nx-1)*dx;
S = S0*exp(x);

NoGain = zeros(Na,Nx);
PartGain = zeros(Na,Nx);
FullGain = zeros(Na,Nx);
for j = 1:Nx
    NoGain(:,j) = (max(S(j)-K,0).*((S(j)-K) < Targ-A));
    PartGain(:,j) = (max(S(j)-K,0).*((S(j)-K) < Targ-A)+(Targ-A).*((S(j)-K) > Targ-A));
    FullGain(:,j) = (max(S(j)-K,0));
end
subplot(3,1,1)
surf(S,A,NoGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
ylim([0,0.5])
zlim([0 0.5])
view(-20,55)
title('\fontsize{18} No gain cash flow')
xlabel('\fontsize{14} S')
ylabel('\fontsize{14} A')
zlabel('\fontsize{14} Cash flow C')

set(gca,'fontsize',14)

subplot(3,1,2)
surf(S,A,PartGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
ylim([0,0.5])
zlim([0 0.5])
view(-20,55)
title('\fontsize{18} Part gain cash flow')
xlabel('\fontsize{14} S')
ylabel('\fontsize{14} A')
zlabel('\fontsize{14} Cash flow C')

set(gca,'fontsize',14)

subplot(3,1,3)
surf(S,A,FullGain,'EdgeColor','none','LineStyle','none');
xlim([0,2])
ylim([0,0.5])
zlim([0 1])
view(-20,55)
title('\fontsize{18} Full gain cash flow')
xlabel('\fontsize{14} S')
ylabel('\fontsize{14} A')
zlabel('\fontsize{14} Cash flow C')

set(gca,'fontsize',14)