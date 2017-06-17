% clear
clc
close all
%% Market data
[Prices,Strikes,Maturity,r,q,OptioType] = importfile('USDCHF_20170523_mid.csv',2, 122);
%filter = Maturity >= 1/12;
%Data = [Prices(filter),Strikes(filter),Maturity(filter),r(filter),q(filter),OptioType(filter)];
Data = [Prices,Strikes,Maturity,r,q,OptioType];
options = optimset('display','iter','FunValCheck', 'on', 'MaxFunEvals', 5000, 'MaxIter', 5000);
opts = optimoptions(@fmincon,'Algorithm','interior-point');
gs = GlobalSearch('Display','iter');
%% Option Parameters
S0  = 0.9730;
K   = [0.9275*ones(1,2) 0.935*ones(1,4) 0.942*ones(1,46)];
r   = -0.01237;
q   =  0.01197;
F_fixDates = 52;
Period = 1/52;
T = Period*F_fixDates;
gaiF_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 2;
Targ = 0.4;
KO = 'F';
ApF = 40000;
%% Models
%  Black-Scholes
sigma = 0.07908; %bid = 0.07636; mid = 0.7908; ask = 0.08181
param_bs = sigma;
model1 = Model('BS',param_bs);
mid_NORM2_BS = NORM2(model1.param,model1.name,S0,Data,1000);
%%  Merton
param_mer = [0.0649    0.1303   -0.0584    0.1603]; % Calibrated
%% Calibration %
Nx = 1000;
param_mer = fminsearch(@(p) NORM2(p, 'Mer', S0, Data,Nx),param_mer,options);
% lb = [0 0 -Inf 0];
% ub = [Inf Inf Inf Inf];
% param_mer = fmincon(@(p) NORM2(p, 'Mer', S0, Data,Nx),param_mer,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) NORM2(p, 'Mer', S0, Data,Nx),'x0',param_mer,'lb',lb,'ub',ub,'options',opts);
% [param_mer,NORM2_mer] = run(gs,problem);
%%
model2 = Model('Mer',param_mer);
mid_NORM2_Mer = NORM2(model2.param,model2.name,S0,Data,1000);
%%  Kou
param_kou = [0.0665    0.1305    0.0751    3.3154    9.0490]; %0Calibrated
%% Calibration %
Nx = 1000;
param_kou = fminsearch(@(p) NORM2(p, 'Kou', S0, Data,Nx),param_kou,options);
% lb = [0 0 0 0 0];
% ub = [Inf Inf 1 Inf Inf];
% param_kou = fmincon(@(p) NORM2(p, 'Kou', S0, Data,Nx),param_kou,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) NORM2(p, 'Kou', S0, Data,Nx),'x0',param_kou,'lb',lb,'ub',ub,'options',opts);
% [param_kou,NORM2_kou] = run(gs,problem);
%%
model3 = Model('Kou',param_kou);
mid_NORM2_Kou = NORM2(model3.param,model3.name,S0,Data,1000);
%%  NIG
param_nig = [18.8491   -3.9281    0.1250]; % Calibrated
%% Calibration %
Nx = 1000;
param_nig = fminsearch(@(p) NORM2(p, 'NIG', S0, Data,Nx),param_nig,options);
% lb = [0  -Inf  0];
% ub = [Inf Inf Inf];
% param_nig = fmincon(@(p) NORM2(p, 'NIG', S0, Data,Nx),param_nig,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) NORM2(p, 'NIG', S0, Data,Nx),'x0',param_nig,'lb',lb,'ub',ub,'options',opts);
% [param_nig,NORM2_nig] = run(gs,problem);
%%
model4 = Model('NIG',param_nig);
mid_NORM2_NIG = NORM2(model4.param,model4.name,S0,Data,1000);
%%  VG
param_vg = [-0.0324    0.0810    0.2451]; % Calibrated

%% Calibration %
Nx = 1000;
param_vg = fminsearch(@(p) NORM2(p, 'VG', S0, Data,Nx),param_vg,options);
% lb = [-Inf  0  0];
% ub = [Inf Inf Inf];
% param_vg = fmincon(@(p) NORM2(p, 'VG', S0, Data,Nx),param_vg,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) NORM2(p, 'VG', S0, Data,Nx),'x0',param_vg,'lb',lb,'ub',ub,'options',opts);
% [param_vg,NORM2_vg] = run(gs,problem);
%%
model5 = Model('VG',param_vg);
mid_NORM2_VG = NORM2(model5.param,model5.name,S0,Data,1000);

%% Methods
%  Monte Carlo
F_sim = 1e5;
method1 = Method('MC',F_sim);
%  Finite Difference
Nx = 500;
Na = Nx/10;
Nt = Nx/50;
method2 = Method('FD',[Na, Nx, Nt]);
%  Convolution
Nx = 1000;
Na = Nx/10;
alpha = 0;
method3 = Method('Conv',[Na, Nx, alpha]);

%% Pricing
TARN_MC_BS  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Mer = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Kou = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_NIG = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_VG  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);

TARN_FD_BS  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Mer = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Kou = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_NIG = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_VG  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
%
TARN_Conv_BS  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Mer = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Kou = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_NIG = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_VG  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);

Nref_TARN_BS  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
Nref_TARN_Mer  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
Nref_TARN_Kou  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
Nref_TARN_NIG  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);
Nref_TARN_VG  = Option(S0,r,q,K,Period,F_fixDates,gaiF_fun,loss_fun,g,Targ,KO,ApF);

figure
hold on
%
disp('---------- Black-Scholes ----------')
% TARN_MC_BS.set_price(model1,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_BS.price)));
% TARN_FD_BS.set_price(model1,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_BS.price)));
TARN_Conv_BS.set_price(model1,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_BS.price)));

% Nref_TARN_BS.set_price(model1,method3);
% disp(strcat('Ref TARN price with Conv= ',num2str(Nref_TARN_BS.price)));
figure
hold on
disp('---------- Merton -----------------')
% TARN_MC_Mer.set_price(model2,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Mer.price)));
% TARN_FD_Mer.set_price(model2,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_Mer.price)));
TARN_Conv_Mer.set_price(model2,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Mer.price)));

% Nref_TARN_Mer.set_price(model2,method3);
% disp(strcat('Ref TARN price with Conv= ',num2str(Nref_TARN_Mer.price)));

disp('---------- Kou --------------------')
% TARN_MC_Kou.set_price(model3,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Kou.price)));
% TARN_FD_Kou.set_price(model3,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_Kou.price)));
TARN_Conv_Kou.set_price(model3,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Kou.price)));

% Nref_TARN_Kou.set_price(model3,method3);
% disp(strcat('Ref TARN price with Conv= ',num2str(Nref_TARN_Kou.price)));
%%
disp('---------- NIG --------------------')
% TARN_MC_NIG.set_price(model4,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_NIG.price)));
% TARN_FD_NIG.set_price(model4,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_NIG.price)));
TARN_Conv_NIG.set_price(model4,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_NIG.price)));

% Nref_TARN_NIG.set_price(model4,method3);
% disp(strcat('Ref TARN price with Conv= ',num2str(Nref_TARN_NIG.price)));
figure
hold on
disp('---------- VG ---------------------')
% TARN_MC_VG.set_price(model5,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_VG.price)));
% TARN_FD_VG.set_price(model5,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_VG.price)));
TARN_Conv_VG.set_price(model5,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_VG.price)));

% Nref_TARN_VG.set_price(model5,method3);
% disp(strcat('Ref TARN price with Conv= ',num2str(Nref_TARN_VG.price)));