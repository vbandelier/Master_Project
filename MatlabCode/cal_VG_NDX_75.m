function cal_VG_NDX(sigma,theta,nu)
% It requires the function VG_FRFT.m

% sigma = 0.23065153252436;
% theta = -0.70197610213548;
% nu = 0.08440167872024;

% We load all the option data:
S = 1725.52;
strike = (1/S)*[1400 1425 1450 1475 1500 1525 1550 1575 1600 1625 1650 1675 1700 1725 1750 1775 1800 1825 1850 1875 1900 1925];
C_mark = (1/S)*[343.40 321.10 298.90 277.20 255.90 235.15 215.05 195.10 176.55 158.35 140.95 124.45 108.95 94.35 80.80 68.20 57.20 47.00 38.35 30.45 24.00 18.50];
strike = strike';
C_mark = C_mark';
t = 75/365;
r = 0.0244;
S=1;

par = [sigma,theta,nu];
par_new = par;

error=zeros(1,100000);
error(1) = Psi(par,C_mark,S,strike,r,t);

itmax = 100000;   % max iteration
tol = 3e-7;       % error tolerance

hstep = 2;   
hstep1 = 1e-5;

fprintf('Initial values of parameters : \n')
disp(par)
fprintf('Press any key \n')
pause

k = 1; ifl = 0;
while(ifl == 0)
   	k = k+1;
   	if(k > itmax)
       	ifl = 1;
   	end
   	if(error(k-1) < tol)
       	fprintf('Calibrated parameters : \n')
       	disp(par)
       	ifl=1;
   		else
       	for j = 1:3
           	par_aux = par;
           	par_aux(j)=par_aux(j) + hstep1;
           	error_aux = Psi(par_aux,C_mark,S,strike,r,t);
           	grad(j)=(error_aux - error(k-1))/hstep1;
       	end
       	for j = 1:3
           	par_new(j) = par(j) - hstep*grad(j);
       	end
       	error(k) = Psi(par_new,C_mark,S,strike,r,t);
   	end
   	error(k);
   	par = par_new;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Functions that compute the program %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = Psi(par,C_mark,S,strike,r,t)
C_actual = VGprice(par,S,strike,r,t);
C_market = C_mark;
y = sum((C_actual - C_market).^2)

function y = VGprice(par,S,strike,r,t)
sigma = par(1); theta = par(2);
nu = par(3);
for i=1:22
        dc(i) = VG_FRFT(S,strike(i),r,t,sigma,theta,nu);
end
y = dc';