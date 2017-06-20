function cal_NIG_RUT(alph,beta,delta)
% It requires the function NIG_FRFT.m

% alph = -18.601;
% beta = -12.247;
% delta = 0.835;

% We load all the option data:
S = 680.73;
strike = (1/S)*[550 560 570 580 590 600 610 620 630 640 650 660 670 680 690 700 710 720 730 740 750 760 770 780];
C_mark = (1/S)*[139.05 130.65 122.45 114.40 106.50 98.90 91.45 84.15 77.25 70.45 63.95 57.55 51.65 46.05 40.90 35.80 31.25 27.10 23.25 19.75 16.75 14.05 11.55 9.55];
strike = strike';
C_mark = C_mark';
t = 110/365;
r = 0.0082;
S=1;

par = [alph,beta,delta];
par_new = par;

error=zeros(1,100000);
error(1) = Psi(par,C_mark,S,strike,r,t);

itmax = 100000;   	% max iteration
tol = 1.5e-5;       % error tolerance

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
C_actual = NIGprice(par,S,strike,r,t);
C_market = C_mark;
y = sum((C_actual - C_market).^2)

function y = NIGprice(par,S,strike,r,t)
alph = par(1); beta = par(2);
delta = par(3);
for i=1:24
        dc(i) = NIG_FRFT(S,strike(i),r,t,delta,alph,beta);
end
y = dc';