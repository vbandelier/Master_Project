%% Option Parameters
S0  = 0.9730;
K   = [0.9275*ones(1,2) 0.935*ones(1,4) 0.942*ones(1,46)];
r   = -0.01237;
q   =  0.01197;
N_fixDates = 1;
Period = 1;
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
Nx = [250,500,1000,2000,4000,8000,16000,32000,64000,128000];
w = 2.^(-5:5);

TARN  = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Targ,KO,ApF);
conv = Method('Conv',[1,100000,0]);
price_ref = Pricer(TARN,model,conv);
%%
prices = nan(length(Nx),length(w));
opt_prices = nan(size(Nx));
global epsi;
for j = 1:length(w)
for i = 1:length(Nx)
    disp([j, i])
    N = Nx(i);
    epsi = max(w(j)*6/250,6/N);
    method = Method('FD',[1, N, 12]);
    
    prices(i,j) = Pricer(TARN,model,method);
end
end
%%
for i = 1:length(Nx)
    disp(i)
    N = Nx(i);
    epsi = 16*6./N;
    method = Method('FD',[1, N, 12]);
    
    opt_prices(i) = Pricer(TARN,model,method);
end
%% loglog
figure
for j = 6:length(w)
loglog(Nx,abs(prices(:,j)-price_ref),'-*','linewidth',1)
hold on
end

loglog(Nx,abs(opt_prices-price_ref),'-*k','linewidth',1)
loglog(Nx,(6./Nx),':k')
loglog(Nx,(6./Nx).^2,'-.k')
%l = legend('$\epsilon = max(0.00075, \Delta x)$',...
           %'$\epsilon = max(0.0015, \Delta x)$',...
           %'$\epsilon = max(0.003, \Delta x)$',...
           %'$\epsilon = max(0.006, \Delta x)$',...
           %'$\epsilon = max(0.012, \Delta x)$',...
 l = legend('$\epsilon = max(0.024, \Delta x)$',...
           '$\epsilon = max(0.048, \Delta x)$',...
           '$\epsilon = max(0.096, \Delta x)$',...
           '$\epsilon = max(0.192, \Delta x)$',...
           '$\epsilon = max(0.384, \Delta x)$',...
           '$\epsilon = max(0.768,\Delta x)$',...
           '$\epsilon = 16\Delta x$',...
           '$\Delta x$','$\Delta x^2$');
 set(l,'Interpreter','latex','fontsize',12)
 xlabel('\fontsize{14} log(Nx)')
 ylabel('\fontsize{14} error')
 tit = title(model.name);
 set(tit,'fontsize',18)
    