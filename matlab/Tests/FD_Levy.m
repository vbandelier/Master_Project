clear
clc
% Option pramaters
r = 0.1;
T = 1;
K = 10;
initial_cond = @(x) max(exp(x)-K,0);
ext_left = @(x,t) 0.*x.*t;
ext_right = @(x,t) (exp(x)-K*exp(-r*t)); 

alpha = 10;

% Method paramters
x_min = log(3);
x_max = log(20);
q_min = -6;
q_max = 6;
Nx = 500;
Nt = 0.05*Nx^2;
q_inf = 100;

tol = 0.0001;
fix_pt_iter = 200;
forcing = @(x,t) 0.*x;
bc_left = @(t) 0.*t;
bc_right = @(t) exp(x_max)-K*exp(-r*t);

nu = 0.2;
theta = -0.14;
sigma = 0.12;
epsi = 0.05;

lambda_p = sqrt(theta^2/sigma^4+2/(sigma^2*nu))-theta/sigma^2;
lambda_n = sqrt(theta^2/sigma^4+2/(sigma^2*nu))+theta/sigma^2;
tic
[V,FD_grid,time_steps] =  VG_solver(sigma,r,lambda_p, lambda_n, nu,forcing,...
                                              bc_left,bc_right,initial_cond,...
                                              x_min,x_max,q_min,q_max,q_inf,ext_left,ext_right,...
                                              Nx,T,Nt,epsi,fix_pt_iter,tol);
toc
surf(time_steps,FD_grid,V)
