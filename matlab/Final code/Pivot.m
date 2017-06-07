clc
close all
%% Market data
[Prices,Strikes,Maturity,r,q,Option_type] = importfile('EURUSD_20170524_ask.csv',2, 111);
Data = [Prices,Strikes,Maturity,r,q,Option_type];
options = optimset('display','iter','FunValCheck', 'on', 'MaxFunEvals', 5000, 'MaxIter', 5000);
% opts = optimoptions(@fmincon,'Algorithm','interior-point');
% gs = GlobalSearch('Display','iter');
%% Option Parameters
S0  = 1.1187;
K   = 0;
r   = 0.01187;
q   = -0.00778;
N_fixDates = 12;
Period = 1/12;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-1.06,0).*(S<1.1180)+max(1.1775-S,0).*(S>=1.1180);
loss_fun = @(S,K) max(1.06-S,0).*(S<=1.06)+max(S-1.1775,0).*(S>1.1775);
g = 2;
Targ = 0.2;
KO = 'F';
ApF = 375000;
%% Models
%  Black-Scholes
sigma = 0.07880; %bid =0.07745 ; mid = 0.0788; ask =0.08015 ; 
param_bs = sigma;
model1 = Model('BS',param_bs);
RMSE_BS = RMSE(model1.param,model1.name,S0,Data,1000);
%%  Merton
param_mer = [0.0669    0.1040   -0.0504    0.1650]; % Calibrated
%% Calibration %
Nx = 1000;
param_mer = fminsearch(@(p) RMSE(p, 'Mer', S0, Data,Nx),param_mer,options);
% lb = [0 0 -Inf 0];
% ub = [Inf Inf Inf Inf];
% param_mer = fmincon(@(p) RMSE(p, 'Mer', S0, Data,Nx),param_mer,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) RMSE(p, 'Mer', S0, Data,Nx),'x0',param_mer,'lb',lb,'ub',ub,'options',opts);
% [param_mer,RMSE_mer] = run(gs,problem);
%%
model2 = Model('Mer',param_mer);
RMSE_Mer = RMSE(model2.param,model2.name,S0,Data,1000);
%%  Kou
param_kou = [0.0657    0.2065    0.5726   16.0440    8.3150]; %0Calibrated
%% Calibration %
Nx = 1000;
param_kou = fminsearch(@(p) RMSE(p, 'Kou', S0, Data,Nx),param_kou,options);
% lb = [0 0 0 0 0];
% ub = [Inf Inf 1 Inf Inf];
% param_kou = fmincon(@(p) RMSE(p, 'Kou', S0, Data,Nx),param_kou,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) RMSE(p, 'Kou', S0, Data,Nx),'x0',param_kou,'lb',lb,'ub',ub,'options',opts);
% [param_kou,RMSE_kou] = run(gs,problem);
%%
model3 = Model('Kou',param_kou);
RMSE_Kou = RMSE(model3.param,model3.name,S0,Data,1000);
%%  NIG
param_nig = [23.0248   -3.0954    0.1500]; % Calibrated
%% Calibration %
Nx = 1000;
param_nig = fminsearch(@(p) RMSE(p, 'NIG', S0, Data,Nx),param_nig,options);
% lb = [0  -Inf  0];
% ub = [Inf Inf Inf];
% param_nig = fmincon(@(p) RMSE(p, 'NIG', S0, Data,Nx),param_nig,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) RMSE(p, 'NIG', S0, Data,Nx),'x0',param_nig,'lb',lb,'ub',ub,'options',opts);
% [param_nig,RMSE_nig] = run(gs,problem);
%%
model4 = Model('NIG',param_nig);
RMSE_NIG = RMSE(model4.param,model4.name,S0,Data,1000);
%%  VG
param_vg = [-0.0235    0.0802    0.1658]; % Calibrated

%% Calibration %
Nx = 1000;
param_vg = fminsearch(@(p) RMSE(p, 'VG', S0, Data,Nx),param_vg,options);
% lb = [-Inf  0  0];
% ub = [Inf Inf Inf];
% param_vg = fmincon(@(p) RMSE(p, 'VG', S0, Data,Nx),param_vg,[],[],[],[],lb,ub,[],options);
% problem = createOptimProblem('fmincon','objective',...
%  @(p) RMSE(p, 'VG', S0, Data,Nx),'x0',param_vg,'lb',lb,'ub',ub,'options',opts);
% [param_vg,RMSE_vg] = run(gs,problem);
%%
model5 = Model('VG',param_vg);
RMSE_VG = RMSE(model5.param,model5.name,S0,Data,1000);

%% Methods
%  Monte Carlo
N_sim = 1e5;
method1 = Method('MC',N_sim);
%  Finite Difference
Na = 50;
Nx = 500;
Nt = 10;
method2 = Method('FD',[Na, Nx, Nt]);
%  Convolution
Na = 200;
Nx = 2000;
alpha = 0;
method3 = Method('Conv',[Na, Nx, alpha]);

%% Pricing
% TARN_MC_BS= Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_MC_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_MC_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_MC_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_MC_VG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% 
% TARN_FD_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_FD_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_FD_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_FD_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
% TARN_FD_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

TARN_Conv_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

% figure
% hold on

disp('---------- Black-Scholes ----------')
% TARN_MC_BS.set_price(model1,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_BS.price)));
% TARN_FD_BS.set_price(model1,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_BS.price)));
TARN_Conv_BS.set_price(model1,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_BS.price)));

disp('---------- Merton -----------------')
% TARN_MC_Mer.set_price(model2,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Mer.price)));
% TARN_FD_Mer.set_price(model2,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_Mer.price)));
TARN_Conv_Mer.set_price(model2,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Mer.price)));

disp('---------- Kou --------------------')
% TARN_MC_Kou.set_price(model3,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Kou.price)));
% TARN_FD_Kou.set_price(model3,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_Kou.price)));
TARN_Conv_Kou.set_price(model3,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Kou.price)));

disp('---------- NIG --------------------')
% TARN_MC_NIG.set_price(model4,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_NIG.price)));
% TARN_FD_NIG.set_price(model4,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_NIG.price)));
TARN_Conv_NIG.set_price(model4,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_NIG.price)));

disp('---------- VG ---------------------')
% TARN_MC_VG.set_price(model5,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_VG.price)));
% TARN_FD_VG.set_price(model5,method2);
% disp(strcat('TARN price with FD  = ',num2str(TARN_FD_VG.price)));
TARN_Conv_VG.set_price(model5,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_VG.price)));
