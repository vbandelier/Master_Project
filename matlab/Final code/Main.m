clear
%% Option Parameters
S0  = 1.05;
K   = 1;
r   = 0.02;
q   = 0.03;
N_fixDates = 20;
Period = 30/360;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 0;
Targ = 0.5;
KO = 'P';
%% Models
%  Black-Scholes
sigma = 0.0502;
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
alpha = 28;
beta = -15;
delta = 0.3;
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
%  Finite Difference
Na = 50;
Nx = 500;
Nt = 25;
method2 = Method('FD',[Na, Nx, Nt]);
%  Convolution
Na = 100;
Nx = 1000;
alpha = 0;
param = [Na, Nx, alpha];
method3 = Method('Conv',[Na, Nx, alpha]);

%% Pricing
TARN = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO);
CALL = Option(S0,r,q,K,1,1,gain_fun,loss_fun,0,1000,KO);
PUT  = Option(S0,r,q,K,1,1,loss_fun,gain_fun,0,1000,KO);
hold on
% CALL.set_price(model5,method1);
% disp(strcat('Call price with MC  = ',num2str(CALL.price)));
% CALL.set_price(model4,method2);
% disp(strcat('Call price with FD  = ',num2str(CALL.price)));
% CALL.set_price(model4,method3);
% disp(strcat('Call price with Conv= ',num2str(CALL.price)));
% 
% PUT.set_price(model5,method1)
% disp(strcat('Put price with MC  = ',num2str(PUT.price)));
% PUT.set_price(model5,method2)
% disp(strcat('Put price with FD  = ',num2str(PUT.price)));
% PUT.set_price(model5,method3)
% disp(strcat('Put price with Conv= ',num2str(PUT.price)));

TARN.set_price(model2,method1);
disp(strcat('TARN price with MC  = ',num2str(TARN.price)));
TARN.set_price(model2,method2);
disp(strcat('TARN price with FD  = ',num2str(TARN.price)));
TARN.set_price(model2,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN.price)));

TARN.set_price(model3,method1);
disp(strcat('TARN price with MC  = ',num2str(TARN.price)));
TARN.set_price(model3,method2);
disp(strcat('TARN price with FD  = ',num2str(TARN.price)));
TARN.set_price(model3,method3);
disp(strcat('TARN price with Conv= ',num2str(TARN.price)));