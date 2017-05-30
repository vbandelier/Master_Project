clear

%% Market data
[Prices,Strikes,Maturity,r,q,Option_type] = importfile('Market_data.csv',2, 122);
Market_data = [Prices,Strikes,Maturity,r,q,Option_type];
filter1 = Market_data(:,3)>2/365;
filter2 = Market_data(:,6)==1;
filter = logical(filter1.*filter2);
Data = Market_data(filter1,:);
%% Option Parameters
S0  = 1.0962;
K   = S0/1.05;
r   = -0.0034;
q   = -0.0076;
N_fixDates = 12;
Period = 30/360;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 0;
Targ = 0.5;
KO = 'F';
%% Models
%  Black-Scholes
sigma = 0.0502;
param_bs = sigma;
model1 = Model('BS',param_bs);
%%  Merton
% sigma   = 0.0502;
% lambda  = 1;        
% alpha   = 0.1;      
% delta   = 0.1;      
% param_mer = [sigma,lambda,alpha,delta];
% param_mer = [0.0258    0.1386    0.0635    0.1941]; % Only with call
param_mer = [0.0223    0.8787    0.0153    0.0528];
model2 = Model('Merton',param_mer);
%%  Kou
% sigma   = 0.05;       
% lambda  = 1;        
% p       = 0.5;   
% eta1    = 50;          
% eta2    = 50;         
% param_kou = [sigma, lambda, p, eta1, eta2];
% param_kou = [0.0103    3.1514    0.4942   58.1519   58.1519]; % Only with call
param_kou = [0.0208    1.3953    0.6126   29.1263   37.1209];
model3 = Model('Kou',param_kou);
%%  NIG
% alpha = 28;     
% beta  =-15;    
% delta = 0.3;  
% param_nig = [alpha,beta,delta];
% param_nig = [10.2623    3.3836    0.0338]; % Only with call
param_nig = [15.0378    5.3048    0.0420];
model4 = Model('NIG',param_nig);
%%  VG
% theta =  0.0039;
% sigma =  0.0338;
% nu    =  28.4765;
% param_vg = [theta,sigma,nu];
% param_vg = [0.0143    0.0545    0.9621]; % Only with call
param_vg = [0.0186    0.0525    0.7280];
model5 = Model('VG',param_vg);

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

%% Calibration
% RMSE = RMSE(0.0502, 'BS', S0, Data)
% lb = [ 0 0 0 0 0 ];
% ub = [ Inf Inf 1 Inf Inf];
% options = optimset('Display','iter','MaxFunEvals', 5000, 'MaxIter', 5000);
% param_kou_1 = fmincon(@(p) RMSE(p, 'Kou', S0, Data),param_kou,[],[],[],[], lb, ub, [], options)
% param_kou = fminsearch(@(p) RMSE(p, 'Kou', S0, Data),param_kou_1, options)

%% Pricing
% TARN_MC_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_MC_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_MC_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_MC_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_MC_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);

TARN_FD_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
TARN_FD_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
TARN_FD_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
TARN_FD_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
TARN_FD_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);

% TARN_Conv_BS  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_Conv_Mer = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_Conv_Kou = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_Conv_NIG = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
% TARN_Conv_VG  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);

figure
hold on

disp('---------- Black-Scholes ----------')
% TARN_MC_BS.set_price(model1,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_BS.price)));
% TARN_FD_BS.set_price(model1,method2);
% disp(TARN_FD_BS.price)
% TARN_Conv_BS.set_price(model1,method3);
% disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_BS.price)));

disp('---------- Merton -----------------')
% TARN_MC_Mer.set_price(model2,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Mer.price)));
% TARN_FD_Mer.set_price(model2,method2);
% disp(TARN_FD_Mer.price)
% TARN_Conv_Mer.set_price(model2,method3);
% disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Mer.price)));

disp('---------- Kou --------------------')
% TARN_MC_Kou.set_price(model3,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_Kou.price)));
TARN_FD_Kou.set_price(model3,method2);
disp(TARN_FD_Kou.price)
% TARN_Conv_Kou.set_price(model3,method3);
% disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_Kou.price)));

disp('---------- NIG --------------------')
% TARN_MC_NIG.set_price(model4,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_NIG.price)));
TARN_FD_NIG.set_price(model4,method2);
disp(TARN_FD_NIG.price)
% TARN_Conv_NIG.set_price(model4,method3);
% disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_NIG.price)));

disp('---------- VG ---------------------')
% TARN_MC_VG.set_price(model5,method1);
% disp(strcat('TARN price with MC  = ',num2str(TARN_MC_VG.price)));
TARN_FD_VG.set_price(model5,method2);
disp(TARN_FD_VG.price);
% TARN_Conv_VG.set_price(model5,method3);
% disp(strcat('TARN price with Conv= ',num2str(TARN_Conv_VG.price)));
