S0  = 0.9730;
K = 0.942;
r   = -0.01237;
q   =  0.01197;
T = 1;

Opt_type = -1;
gain_fun = @(S,K) max(Opt_type*(S-K),0);

option = Option(S0,r,q,K,T,1,gain_fun,@(S,K) 0.*S,0,1000,'F',1); 

param_vg = [-0.0324    0.0810    0.2451];
model = Model('VG',param_vg);

Nx = 2^20;
Na = 1;
method = Method('Conv',[Na, Nx, -2*Opt_type]);
price = Pricer(option,model,method);