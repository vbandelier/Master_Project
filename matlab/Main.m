clear
clc
rng(0)
%% Parameters
S0 = 1.05;
K   = 1.0;
r_d = -0.012;
r_f = 0.007;
sigma = 0.2;

N_fixDates = 20;
Period = 30/365;

Nx = 500;
Nt = 25;
N = 2^10;
Na = 100;
N_sim = 1e5;
q_order = 100;
alpha = 0; % Damping Factor

Targets= [0.3 0.5 0.7 0.9];

theta=0.5;

gainFun = @(s,x) max(s-x,0).*ones(size(s));
KO_type = ['noGain  ';...
    'partGain';...
    'fullGain'];

%% Tarn Pricing
Prices_GHQC = zeros(4,3);
Prices_FD = zeros(4,3);
Prices_MC = zeros(4,3);
Prices_QUAD = zeros(4,3);
Prices_CONV = zeros(4,3);
%%
figure
k = 1;
for j = 1:3
    KO = KO_type(j,:);
    for i = 2
        subplot(1,3,k)  
        hold on
        Targ = Targets(i);
        tic
        Prices_MC(i,j) = MCTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N_sim,gainFun,KO);
        Prices_FD(i,j) = FDTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Nt,Na,KO,theta);
        Prices_GHQC(i,j) = GHQCTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,Nx,Na,KO,q_order);
        Prices_QUAD(i,j) = QUADTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N,Na,KO);
        Prices_CONV(i,j) = CONVTarnPricing(S0,K,r_d,r_f,sigma,Period,Targ,N_fixDates,N,Na,KO,alpha);
        toc
        k = k+1;
    end
end
%% Results
MC = reshape(Prices_MC,12,1);
FD = reshape(Prices_FD,12,1);
GHQC = reshape(Prices_GHQC,12,1);
QUAD = reshape(Prices_QUAD,12,1);
CONV = reshape(Prices_CONV,12,1);

KO_Type = {'No Gain';'No Gain';'No Gain';'No Gain';...
    'Part Gain';'Part Gain';'Part Gain';'Part Gain';...
    'Full Gain';'Full Gain';'Full Gain';'Full Gain'};

Target = repmat(Targets,1,3)';

Table = table(KO_Type,Target,MC,FD,GHQC,QUAD,CONV)
