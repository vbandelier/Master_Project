function [V,FD_grid,time_steps] = VG_solver(sigma,r,q,lambda_p, lambda_n, nu,forcing,...
                                              bc_left,bc_right,initial_cond,...
                                              x_min,x_max,q_min,q_max,q_inf,ext_left,ext_right,...
                                              Nx,T,Nt,epsi,fix_pt_iter,tol)

% function [V,FD_grid,time_steps] = VG_solver(sigma,r,levyf,forcing,...
%                                               bc_left,bc_right,initial_cond,...
%                                               x_min,x_max,q_min,q_max,q_inf,ext_left,ext_right,...
%                                               Nx,T,Nt,epsi,fix_pt_iter,tol)
%
% solves the European Put price equation with a jump process described by a Variance Gamma (VG) process.
%
% The equation is discretized with an Implicit Euler, treating the integral term with a fixed point approach
%
% (V*_{k+1} - V_old) 
% ---------------    + A V*_{k+1}  = f_new + integral(V*_{k}), with V*_0 = V_old   (@@@)
%      Delta t  
%
% ----------------
% Inputs:
% ----------------
%
% sigma         : volatility (real number)
% r             : risk-free return (real number)
% lambda_p, 
% lambda_n,
% nu            : parameters for the levy measure for jumps. 
%                   levyf = @(x) exp(-lambda_n * abs(x))./( nu * abs(x) ) .*(x<0) + ...
%                   exp(-lambda_p * x     )./( nu* x) .*(x>0) ; 
%                   for some real parameters lambda_p, lambda_n, nu. 
% forcing       : @(x,t)-function describing the right-hand-side of the equation
% bc_left       : @(t)-function describing the boundary condition on the left border
% bc_right      : @(t)-function describing the boundary condition on the right border
% initial_cond  : @(x)-function describing the initial condition of the problem
% x_min, x_max  : real values setting the extrema of the interval in which the solution is computed
% Nx            : number intervals in [x_min,x_max]. 
% q_min, q_max  : real values setting the extrema of the interval used to approximate the integral term.
%                   (q_min, q_max) should contain (x_min, x_max). The quadrature grid will use the same
%                   step-size of the finite difference grid (x_min, x_max)
% ext_left      : @(x,t)-function describing how the solution in (x_min,x_max) should be extended in (q_min,x_min)
% ext_right     : @(x,t)-function describing how the solution in (x_min,x_max) should be extended in (x_max,q_max)           
% T             : final time of the equation
% Nt            : number of time-steps 
% fix_pt_iter   : maximum number of iterations for fixed point resolution of the implicit treatment of the
%                   integral (@@@). If fix_pt_iter is not passed as input, then (***) is solved instead
% tol           : tolerance for the fixed point iterations. 
%
% ----------------
% Outputs:
% ----------------
%
% V             : matrix containing the solution of the PDE. Each column represents the solution 
%                   on the whole spatial grid at a single time
% FD_grid       : spatial discretization of (x_min, x_max)
% time_steps    : time grid, contains the time steps at which V is computed


% levy functions are defined as  subfunction (i.e. secondary functions defined at the end this file
% and only visible to each other and to the curren function, but not in the matlab workspace)


if(q_min>0), error('q_min must be smaller than 0'), end


% set grid and grid-size.
h = (x_max-x_min)/Nx;
FD_grid = linspace(x_min,x_max,Nx+1); 
inner_grid = FD_grid(2:end-1);

% we need to extend the finite difference grid leftward up to q_min and rightward up to q_max
% to create the quadrature grid to approximate the integral term. The length of the two extensions
% is (q_max-x_max) and (x_min-q_min), which are not necessarily multiples of h. Thus, in practice
% we will not reach exactly q_max (and q_min), but we will stop as soon as we are within h distance
% from q_max (and q_min).

quad_grid_right = x_max + ( 0:h:(q_max - x_max) ); % note that both parentheses are needed here

% the code to extend to the left is sligthly more complex. Fliplr is a matlab function that 
% flips a vector in left/right direction, e.g. fliplr([1 2 3])=[3 2 1]
quad_grid_left = fliplr(x_min - ( 0:h:(x_min - q_min) ) ); 

quad_grid  = [quad_grid_left inner_grid quad_grid_right];
Nq = length(quad_grid)-1;

% set number of time steps
deltat = T/Nt;
time_steps = [0 deltat*(1:Nt)];

% init matrix containing the solution at each time step
V=zeros(length(FD_grid),Nt+1);
V(:,1)=initial_cond(FD_grid)';

% we need to determine the constants sigma_epsi, lambda_epsi, c_epsi. Note that f(y) may be singular in zero,
% therefore we need to split the integration in -epsi<y<0 and 0<y<epsi. The obvious choice is epsi = h

sigma_epsi =  sqrt(integral(@(y) y.^2.*(levyf(lambda_p,lambda_n,nu,y)-levyf_epsi(lambda_p,lambda_n,nu,epsi,y)), -epsi, 0 ) ...
                 + integral(@(y) y.^2.*(levyf(lambda_p,lambda_n,nu,y)-levyf_epsi(lambda_p,lambda_n,nu,epsi,y)), 0, epsi) );
lambda_epsi = integral(@(y) levyf_epsi(lambda_p,lambda_n,nu,epsi,y), -q_inf, +q_inf);
c_epsi = integral(@(y) (exp(y)-1).*levyf_epsi(lambda_p,lambda_n,nu,epsi,y), -q_inf, q_inf) ;

% sigma_epsi =  sqrt(integral(@(y) y.^2.*(levyf(lambda_p,lambda_n,nu,y)), -epsi, 0 ) ...
%                  + integral(@(y) y.^2.*(levyf(lambda_p,lambda_n,nu,y)), 0, epsi) );
% lambda_epsi = integral(@(y) levyf(lambda_p,lambda_n,nu,y), -q_inf, -epsi)...
%                  +integral(@(y) levyf(lambda_p,lambda_n,nu,y), epsi, q_inf);
% c_epsi = integral(@(y) (exp(y)-1).*levyf(lambda_p,lambda_n,nu,y), -q_inf, -epsi)...
%                  +integral(@(y) (exp(y)-1).*levyf(lambda_p,lambda_n,nu,y), epsi, q_inf);


disp('-----------------------------')
disp('epsi constant values')
disp(strcat('sigma_epsi=',num2str(sigma_epsi)))
disp(strcat('lambda_epsi=',num2str(lambda_epsi)))
disp(strcat('c_epsi=',num2str(c_epsi)))


% the theta-method consists in the formula
%
% [ I + deltat*theta A ] V_new = V_old - deltat*(1-theta) A V_old  + deltat (theta *F_new +(1-theta) F_old ]
%
% we begin by building the matrix A, as in the steady case, and the matrix 
%
% B = [ I + deltat*theta A ] 
%
% We will solve the linear system in B, hence we only need its diagonals, while we need
% to build A (as in the Forward Euler)


aa_up   = -0.5*(sigma^2+sigma_epsi^2)*ones(Nx-2,1)/h^2;
aa_main =  0.5*(sigma^2+sigma_epsi^2)*2*ones(Nx-1,1)/h^2;
aa_down = -0.5*(sigma^2+sigma_epsi^2)*ones(Nx-2,1)/h^2;

bb_up = -(r-q-(sigma^2+sigma_epsi^2)/2-c_epsi)*ones(Nx-2,1)/(2*h);
bb_down = (r-q-(sigma^2+sigma_epsi^2)/2-c_epsi)*ones(Nx-2,1)/(2*h);

cc_main = (r+lambda_epsi)*ones(Nx-1,1);

B_up = deltat*(aa_up+bb_up);
B_main = deltat*(aa_main+cc_main)+ones(Nx-1,1);
B_down = deltat*(aa_down+bb_down);



% ------------------------------------------------
% use FFT to compute the integral term %             
% -----------------------------------------------
%
% the integral term to approximate is 
%
% int_{q_min}^{q_max} V(z,t) levyf(z-x) dz \approx  sum_i V(z_i,t)*levyf(z_i-x)*h 
%
% which is a convolution. Hence it is convenient to compute it with FFT.
% To this end, we will need a vector containing all possible points where I will
% evaluate levyf

levy_grid = (quad_grid(1) - inner_grid(end)  ) : h : (quad_grid(end) - inner_grid(1) ); 
levyf_vals = levyf_epsi(lambda_p,lambda_n,nu,epsi,levy_grid);
fftJ=fft(h*levyf_vals);

% and then the fft of V, which is to be computed at each time step. We can then
% approximate the integral by dot-multiplying the transforms and inverse-transforming.


for tn = 1:Nt
    
    t_new=tn*deltat;

    V_left = ext_left(quad_grid_left,t_new);
    V_right = ext_right(quad_grid_right,t_new);

    iter=0;
    
    Vstar = [V_left V(2:end-1,tn)' V_right];
    Vstar_old = 0*Vstar;
        
    while max(abs(Vstar_old-Vstar))>tol && iter<fix_pt_iter
        
        iter=iter+1;
        
        % 1) forcing at the new time-step, with boundary conditions
        f_new = forcing(inner_grid,t_new)' ;

        corr_left_new = 0.5*(sigma^2+sigma_epsi^2)*bc_left(t_new)/h^2 - (r-(sigma^2+sigma_epsi^2)/2-c_epsi)*bc_left(t_new)/(2*h);
        corr_right_new = 0.5*(sigma^2+sigma_epsi^2)*bc_right(t_new)/h^2 + (r-(sigma^2+sigma_epsi^2)/2-c_epsi)*bc_right(t_new)/(2*h);
        f_new(1) =  f_new(1) + corr_left_new;
        f_new(end) =  f_new(end) + corr_right_new;
        
        
        % 2) the integral term with FFT
        fftV=fft([zeros(1,length(levy_grid)-Nq-1) Vstar]);
        fcomp=ifft(conj(fftJ).*fftV);
        f_new = f_new + fcomp(1:Nx-1)';

        % 3) the solution at the previous time step
        f_tot = V(2:end-1,tn) + deltat*f_new ;

        % ----------------------
        % finally, solve the system and store the solution
        % -----------------------
        
%         sol = thomas(B_down,B_main,B_up,f_tot);
        B = sparse(1:Nx-2,2:Nx-1,B_up,Nx-1,Nx-1) + ...
            sparse(1:Nx-1,1:Nx-1,B_main,Nx-1,Nx-1)+...
            sparse(2:Nx-1,1:Nx-2,B_down,Nx-1,Nx-1);
            
        sol = B\f_tot;
        
        Vstar_old = Vstar;
        Vstar=[V_left  sol'  V_right];
    end
    
    V(:,tn+1)=[bc_left(t_new); sol; bc_right(t_new)];

end


function res = levyf(lambda_p,lambda_n,nu,x)

if iscolumn(x)
    x=x';
end

xneg=x(x<0);
xzero=x(x==0);
xpos=x(x>0);

res = [exp(-lambda_n*abs(xneg))./( nu*abs(xneg)), Inf(1,length(xzero)) exp(-lambda_p*xpos)./(nu*xpos)];



function res = levyf_epsi(lambda_p,lambda_n,nu,epsi,x)

if iscolumn(x)
    x=x';
end

xleft=x(x<-epsi);
%xcenter=x( logical( (x>-epsi) .* (x<epsi) ) );
xcenter=x( ~(x<-epsi) & ~(x>epsi) );
xright=x(x>epsi);

v1=levyf(lambda_p,lambda_n,nu,epsi);
v2=levyf(lambda_p,lambda_n,nu,-epsi);
m = ( v1-v2 ) / (2*epsi);

res = [exp(-lambda_n*abs(xleft))./( nu*abs(xleft)),  v1+m*(xcenter-epsi),  exp(-lambda_p*xright)./(nu*xright)];
