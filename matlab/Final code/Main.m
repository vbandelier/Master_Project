clear
clc
%% Market data
[Prices,Strikes,Maturity,r,q,Option_type] = importfile('Market_data.csv',2, 111);
Data = [Prices,Strikes,Maturity,r,q,Option_type];
options = optimset('display','iter','FunValCheck', 'on', 'MaxFunEvals', 5000, 'MaxIter', 5000);
opts = optimoptions(@fmincon,'Algorithm','interior-point');
gs = GlobalSearch('Display','iter');
%% Option Parameters
S0  = 0.9730;
K   = [0.9275*ones(1,2) 0.935*ones(1,4) 0.942*ones(1,46)];
r   = -0.01237;
q   =  0.01197;
N_fixDates = 52;
Period = 1/52;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 2;
Targ = 0.4;
KO = 'F';
ApF = 40000;
%% Models
%  Black-Scholes
sigma = 0.08912;
param_bs = sigma;
model1 = Model('BS',param_bs);
RMSE_BS = RMSE(model1.param,model1.name,S0,Data,1000);
%%  Merton
param_mer = [0.0628    0.0225   -0.4609    1.7224]; % Calibrated
% Calibration %
Nx = 500;
lb = [0 0 -Inf 0];
ub = [Inf Inf Inf Inf];
problem = createOptimProblem('fmincon','objective',...
 @(p) RMSE(p, 'Mer', S0, Data,Nx),'x0',param_mer,'lb',lb,'ub',ub,'options',opts);
[param_mer,RMSE_mer] = run(gs,problem);
% param_mer = fmincon(@(p) RMSE(p, 'Mer', S0, Data,Nx),param_mer,[],[],[],[],lb,ub,[],options);

model2 = Model('Mer',param_mer);
RMSE_Mer = RMSE(model2.param,model2.name,S0,Data,1000);
%%  Kou
param_kou = [0.0623    0.2371    0.1552    8.8225   11.9840]; %0Calibrated
% Calibration %
Nx = 500;
lb = [0 0 0 0 0];
ub = [Inf Inf 1 Inf Inf];
problem = createOptimProblem('fmincon','objective',...
 @(p) RMSE(p, 'Kou', S0, Data,Nx),'x0',param_kou,'lb',lb,'ub',ub,'options',opts);
[param_kou,RMSE_kou] = run(gs,problem);
% param_kou = fmincon(@(p) RMSE(p, 'Kou', S0, Data,Nx),param_kou,[],[],[],[],lb,ub,[],options);

model3 = Model('Kou',param_kou);
RMSE_Kou = RMSE(model3.param,model3.name,S0,Data,1000);
%%  NIG
param_nig = [18.6508   -3.8876    0.1188]; % Calibrated

% Calibration %
Nx = 500;
lb = [0  -Inf  0];
ub = [Inf Inf Inf];
problem = createOptimProblem('fmincon','objective',...
 @(p) RMSE(p, 'NIG', S0, Data,Nx),'x0',param_nig,'lb',lb,'ub',ub,'options',opts);
[param_nig,RMSE_nig] = run(gs,problem);
% param_nig = fmincon(@(p) RMSE(p, 'NIG', S0, Data,Nx),param_nig,[],[],[],[],lb,ub,[],options);

model4 = Model('NIG',param_nig);
RMSE_NIG = RMSE(model4.param,model4.name,S0,Data,1000);
%%  VG
param_vg = [-0.0294    0.0796    0.2789]; % Calibrated

% Calibration
Nx = 500;
lb = [-Inf  0  0];
ub = [Inf Inf Inf];
problem = createOptimProblem('fmincon','objective',...
 @(p) RMSE(p, 'VG', S0, Data,Nx),'x0',param_vg,'lb',lb,'ub',ub,'options',opts);
[param_vg,RMSE_vg] = run(gs,problem);
% param_vg = fmincon(@(p) RMSE(p, 'VG', S0, Data,Nx),param_vg,[],[],[],[],lb,ub,[],options);

model5 = Model('VG',param_vg);
RMSE_VG = RMSE(model5.param,model5.name,S0,Data,1000);

%% Methods
%  Monte Carlo
N_sim = 1e6;
method1 = Method('MC',N_sim);
%  Finite Difference
Na = 100;
Nx = 1000;
Nt = 40;
method2 = Method('FD',[Na, Nx, Nt]);
%  Convolution
Na = 200;
Nx = 2000;
alpha = 0;
method3 = Method('Conv',[Na, Nx, alpha]);

%% Pricing
TARN_MC_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_MC_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

TARN_FD_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_FD_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

TARN_Conv_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
TARN_Conv_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);

% figure
% hold on
%%
disp('---------- Black-Scholes ----------')
% TARN_MC_BS.set_price(model1,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_BS.price)));
% TARN_FD_BS.set_price(model1,method2);
% disp(TARN_FD_BS.price)
TARN_Conv_BS.set_price(model1,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_BS.price)));
%%
disp('---------- Merton -----------------')
% TARN_MC_Mer.set_price(model2,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Mer.price)));
% TARN_FD_Mer.set_price(model2,method2);
% disp(TARN_FD_Mer.price)
TARN_Conv_Mer.set_price(model2,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Mer.price)));
%%
disp('---------- Kou --------------------')
% TARN_MC_Kou.set_price(model3,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Kou.price)));
% TARN_FD_Kou.set_price(model3,method2);
% disp(TARN_FD_Kou.price)
TARN_Conv_Kou.set_price(model3,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Kou.price)));
%%
disp('---------- NIG --------------------')
% TARN_MC_NIG.set_price(model4,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_NIG.price)));
% TARN_FD_NIG.set_price(model4,method2);
% disp(TARN_FD_NIG.price)
TARN_Conv_NIG.set_price(model4,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_NIG.price)));
%%
disp('---------- VG ---------------------')
% TARN_MC_VG.set_price(model5,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_VG.price)));
% TARN_FD_VG.set_price(model5,method2);
% disp(TARN_FD_VG.price);
TARN_Conv_VG.set_price(model5,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_VG.price)));
