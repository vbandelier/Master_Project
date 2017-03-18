clear
clc
rng(0)
%% Parameters
S_0 = 1.05;
K  = 1.0;
r_d = 0;
r_f = 0;
sigma = 0.2;

N_fixDates = 20;
Period = 30/365;
Nx = 500;
Nt = 15;
Na = 50;
N_sim = 1e6;

Target= [0.3 0.5 0.7 0.9];

tol = 1e-5;
theta=0.5;

gainFun = @(s,x) max(s-x,0).*ones(size(s));
KO_type = ['noGain  ';...
    'partGain';...
    'fullGain'];

%% Tarn Pricing
Prices_GHQC = zeros(4,3);
Prices_FD = zeros(4,3);
Prices_MC = zeros(4,3);
for i = 1:4
    Targ = Target(i);
    for j = 1:3
        KO = KO_type(j,:);
        tic
        Prices_MC(i,j) = MCTarnPricing(S_0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N_sim,gainFun,KO);
        toc
        tic
        Prices_FD(i,j) = FDTarnPricing(S_0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Nt,Na,KO,theta,tol);
        toc
        tic
        Prices_GHQC(i,j) = GHQCTarnPricing(S_0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Na,KO);
        toc
    end
end
%% Results
printmat(Prices_GHQC, 'GHQC Prices', '0.3 0.5 0.7 0.9', 'noGain partGain fullGain')
printmat(Prices_FD, 'FD Prices', '0.3 0.5 0.7 0.9', 'noGain partGain fullGain')
printmat(Prices_MC, 'MC Prices', '0.3 0.5 0.7 0.9', 'noGain partGain fullGain')
Differences = abs(Prices_FD-Prices_MC);