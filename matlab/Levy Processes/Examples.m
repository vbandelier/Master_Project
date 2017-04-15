clear 
clc
close all

T = 1;
N = 1e3;
dt = T/N;
X0 = 0;
mu = 2;
sigma = 1;
lambda = 5;

time = 0:dt:T;

figure(1)
%% Linear drift
X1 = mu*time;
subplot(2,2,1)
plot(time,X1,'linewidth',1)
title('\fontsize{14} Linear drift')

%% Diffusion processes
X2 = zeros(N+1,1);
for  t = 1:N
    X2(t+1) = X2(t) + mu*dt + sigma*sqrt(dt)*random('norm',0,1);
end
subplot(2,2,2)
plot(time,X2,'linewidth',1)
title('\fontsize{14} Wiener process')

%% Compound Poisson process
I = zeros(N,1);
X3 = zeros(N+1,1);
F = zeros(N+1,1);
for i = 1:N
    I(i) = random('poisson',dt*lambda);
    if I(i) == 0
        F(i) = 0;
    else
        F(i) = random('norm',0,1);
    end
    X3(i+1) = X3(i) + F(i);
end
subplot(2,2,3)
plot(time,X3,'linewidth',1)
title('\fontsize{14} Compound Poisson process')
% Jump Diffusion process
X4 = X2+X3;
subplot(2,2,4)
plot(time,X4,'linewidth',1)
title('\fontsize{14} Jump-diffusion process')

