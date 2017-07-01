%% Option Parameters
S0  = 0.9730;
K   = [0.9275*ones(1,2) 0.935*ones(1,4) 0.942*ones(1,46)];
r   = -0.01237;
q   =  0.01197;
N_fixDates = 6;
Period = 1/6;
T = Period*N_fixDates;
gain_fun = @(S,K) max(S-K,0);
loss_fun = @(S,K) max(K-S,0);
g = 0;
Targ = 0.4;
KO = 'F';
ApF = 1;

param_vg = [-0.0324    0.0810    0.2451];
param_nig = [18.8491   -3.9281    0.1250];

model = Model('NIG',param_nig);
%model = Model('VG',param_vg);

%  Finite Difference
Nx = [250,500,1000,2000,4000];

TARN  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
global epsi;
prices_1 = nan(size(Nx));
prices_2 = nan(size(Nx));
for i = 1:length(Nx)
    i
    N = Nx(i);
    Na = N/10;
    Nt = N/50;
    epsi = 0.05;
    method = Method('FD',[Na, N, Nt]);
    
    prices_1(i) = Pricer(TARN,model,method);
end
for i = 1:length(Nx)
    i
    N = Nx(i);
    Na = N/10;
    Nt = N/50;
    epsi = 16*6/N;
    method = Method('FD',[25, N, 5]);
    
    prices_2(i) = Pricer(TARN,model,method);
end

%% Plot
figure
load('/Users/vmbandel/Desktop/Master_Project/matlab/Final code/Backup/Full_gain_res.mat')
price_ref = Fref_TARN_VG.price;
loglog(Nx,abs(prices_1-price_ref),'-*','linewidth',1)
hold on
loglog(Nx,abs(prices_2-price_ref),'-*k','linewidth',1)
loglog(Nx,3*6./Nx,':k')
loglog(Nx,100*(6./Nx).^2,'-.k')
l = legend('$\epsilon = 0.005$',...
           '$\epsilon = 16\Delta x$',...
           '$\Delta x$','$\Delta x^2$');
 set(l,'Interpreter','latex','fontsize',12)
 tit = title(model.name);
 set(tit,'fontsize',18)
    