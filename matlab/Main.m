clear
clc
rng(0)
%% Parameters
S0 = 1.05;
K   = 1.00;
r_d = 0.00;
r_f = 0.00;
sigma = 0.2;

N_fixDates = 20;
Period = 30/365;

Nx = 500;
Nt = 15;
N = 2^9;
Na = 50;
N_sim = 1e6;
q_order = 100;
alpha = -2; % Damping Factor

Targets= [0.3 0.5 0.7 0.9];

theta=0.5;

gainFun = @(s,x) max(s-x,0).*ones(size(s));
lossFun = @(s,x) max(x-s,0).*ones(size(s));
g = 0;

KO_type = ['noGain  ';...
           'partGain';...
           'fullGain'];

%% Tarn Pricing
Prices_GHQC = zeros(4,3);
Prices_FD = zeros(4,3);
Prices_MC = zeros(4,3);
stdev_MC = zeros(4,3);
Prices_QUAD = zeros(4,3);
Prices_CONV = zeros(4,3);
Prices_Exact = zeros(4,3);
%%
figure
k = 1;
for j = 1:3
    KO = KO_type(j,:);
    for i = 1:4
        subplot(3,4,k)  
        hold on
        Targ = Targets(i);
        tic
        [Prices_MC(i,j),stdev_MC(i,j)] = MCTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N_sim,gainFun,lossFun,g,KO);
        Prices_FD(i,j) = FDTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Nt,Na,gainFun,lossFun,g,KO,theta);
        Prices_GHQC(i,j) = GHQCTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Na,gainFun,lossFun,g,KO,q_order);
        Prices_QUAD(i,j) = QUADTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N,Na,gainFun,lossFun,g,KO);
        Prices_CONV(i,j) = CONVTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N,Na,gainFun,lossFun,g,KO,alpha);
        k = k+1;
        toc
    end
end
%% Results
load('Exact_solution.mat')

Exact = reshape(Prices_Exact,12,1);
MC = reshape(Prices_MC,12,1);
FD = reshape(Prices_FD,12,1);
GHQC = reshape(Prices_GHQC,12,1);
QUAD = reshape(Prices_QUAD,12,1);
CONV = reshape(Prices_CONV,12,1);

KO_Type = {'No Gain';'No Gain';'No Gain';'No Gain';...
           'Part Gain';'Part Gain';'Part Gain';'Part Gain';...
           'Full Gain';'Full Gain';'Full Gain';'Full Gain'};

Target = repmat(Targets,1,3)';

Table = table(KO_Type,Target,Exact,MC,FD,GHQC,QUAD,CONV)

rRMSE_MC = sqrt(mean(((MC-Exact)./Exact).^2))
rRMSE_FD = sqrt(mean(((FD-Exact)./Exact).^2))
rRMSE_GHQC = sqrt(mean(((GHQC-Exact)./Exact).^2))
rRMSE_QUAD = sqrt(mean(((QUAD-Exact)./Exact).^2))
rRMSE_CONV = sqrt(mean(((CONV-Exact)./Exact).^2))
   