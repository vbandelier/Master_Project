% Option pramaters
S0  = 1.09619;
K   = 1;
r   = 0.1;
q   = 0;
T = 1;
initial_cond = @(x) max(S0*exp(x)-K,0);
ext_left = @(x,t) 0.*x.*t;
ext_right = @(x,t) S0*exp(x)-K*exp(-r*t); 

alpha = 10;

% Method paramters
x_min = -5;
x_max = 1;
q_min = -10;
q_max = 6;
Nx = 500;
Nt = 25;
q_inf = 20;

tol = 0.0001;
fix_pt_iter = 200;
forcing = @(x,t) 0.*x;
bc_left = @(t) 0.*t;
bc_right = @(t) S0*exp(x_max)-K*exp(-r*t);

theta = -0.14;
sigma = 0.12;
nu = 0.2;
epsi = 0.05;

lambda_p = sqrt(theta^2/sigma^4+2/(sigma^2*nu))-theta/sigma^2;
lambda_n = sqrt(theta^2/sigma^4+2/(sigma^2*nu))+theta/sigma^2;
tic
[V,FD_grid,time_steps] =  VG_solver(sigma,r,q,lambda_p, lambda_n, nu,forcing,...
                                              bc_left,bc_right,initial_cond,...
                                              x_min,x_max,q_min,q_max,q_inf,ext_left,ext_right,...
                                              Nx,T,Nt,epsi,fix_pt_iter,tol);
toc
% surf(time_steps,exp(FD_grid),V)
price = interp1(S0*exp(FD_grid),V(:,end),S0)
plot(S0*exp(FD_grid),V(:,end),'linewidth',1)