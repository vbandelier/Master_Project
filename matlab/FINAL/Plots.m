clear
clc
rng(1)

S0 = 1;
r = 0.01;
q = 0.02;
sigma = 0.3;
lambda = 10;
% Merton
alpha = -0.05;
delta = 0.1;
% Kou
p = 0.5;
eta1 = 25;
eta2 = 25;
% NIG
a = 50;
b = 3;
c = 1;
% VG
theta = 0.5;
nu = 0.01;

T = 1;
dt = 0.001;
M = 1e4;

[S_BS,t] = BS_generator(S0,r,q,sigma,T,dt,M);
[S_Mer,~] = Merton_generator(S0,r,q,sigma,lambda,alpha,delta,T,dt,M);
[S_Kou,~] = Kou_generator(S0,r,q,sigma,lambda,p,eta1,eta2,T,dt,M);
[S_NIG,~] = NIG_generator( S0,r,q,a,b,c,T,dt,M );
[S_VG,~] = VG_generator( S0,r,q,theta,sigma,nu,T,dt,M );
figure
plot(t,S_BS,'linewidth',1)
title('\fontsize{20} Simulations under Black-Scholes model')
xlabel('\fontsize{16} Time')
ylabel('\fontsize{16} Stock')
figure
plot(t,S_Mer,'linewidth',1)
title('\fontsize{20} Simulations under Merton model')
xlabel('\fontsize{16} Time')
ylabel('\fontsize{16} Stock')
figure
plot(t,S_Kou,'linewidth',1)
title('\fontsize{20} Simulations under Kou model')
xlabel('\fontsize{16} Time')
ylabel('\fontsize{16} Stock')
figure
plot(t,S_NIG,'linewidth',1)
title('\fontsize{20} Simulations under NIG model')
xlabel('\fontsize{16} Time')
ylabel('\fontsize{16} Stock')
figure
plot(t,S_VG,'linewidth',1)
title('\fontsize{20} Simulations under VG model')
xlabel('\fontsize{16} Time')
ylabel('\fontsize{16} Stock')