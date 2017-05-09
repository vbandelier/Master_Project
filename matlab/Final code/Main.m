clear
%% Option Parameters
S0  = 1.05;
K   = 1;
r   = 0.0;
q   = 0.0;
N_fixDates = 20;
T   = N_fixDates*30/365;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 0;
Targ = 0.5;
KO = 'F';       % 'N' = no_gain, 'P' = part_gain, 'F' = full_gain.

%% Models
%  Black-Scholes
sigma = 0.2;
model1 = Model('BS',sigma);
%  Merton
lambda = 1;
alpha = -0.1;
delta = 0.1;
param_mer = [sigma,lambda,alpha,delta];
model2 = Model('Merton',param_mer);
%  Kou
p = 0.4;
eta1 = 30;
eta2 = 50;
param_kou = [sigma,lambda,p,eta1,eta2];
model3 = Model('Kou',param_kou);
%  NIG
alpha = 28.42141;
beta = -15.08623;
delta = 0.31694;
param_nig = [alpha,beta,delta];
model4 = Model('NIG',param_nig);
%  VG
theta = -0.14;
sigma = 0.12;
nu = 0.2;
param_vg = [theta,sigma,nu];
model5 = Model('VG',param_vg);

%% Methods
%  Monte Carlo
N_sim = 1e5;
method1 = Method('MC',N_sim);

%% Pricing
TARN = Option(S0,r,q,K,T,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
tic, Price_BS = Price(TARN,model1,method1), toc
tic, Price_Merton = Price(TARN,model2,method1), toc
tic, Price_Kou = Price(TARN,model3,method1), toc
tic, Price_NIG = Price(TARN,model4,method1), toc
tic, Price_VG = Price(TARN,model5,method1), toc