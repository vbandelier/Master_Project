function cal_JD_DJX
format long

sigma = 0.19;
lambda = 0.45;
jumpa = -0.2;
jumpb = 0.02;

par = [sigma,lambda,jumpa,jumpb];
par_new = par;

Spot = 122.22;
OP = xlsread('DJX.xls');
TD = xlsread('DJX_T.xls');

[no,mo] = size(OP);
strike = OP(:,1)/Spot;
C_mark = OP(:,2:mo)/Spot;
S=1;
t = (1/360)*TD(:,1);
r = TD(:,2);
error=zeros(1,100000);
error(1) = Psi(par,C_mark,S,strike,r,t);

itmax = 100000;   % iterazioni max
tol = 1e-3;     % toleranza dell'errore

hstep = 1e-3;   
hstep1 = 1e-4;

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
        for j = 1:4
            par_aux = par;
            par_aux(j)=par_aux(j) + hstep1;
            error_aux = Psi(par_aux,C_mark,S,strike,r,t);
            grad(j)=(error_aux - error(k-1))/hstep1;
        end
        for j = 1:4
            par_new(j) = par(j) - hstep*grad(j);
        end
        error(k) = Psi(par_new,C_mark,S,strike,r,t);
    end
    error(k);
    par = par_new;
end

%plot(strike,C_mark,'o',strike,option,'*')
%plot(C_mark,'o')
%plot(option,'o')


function y = Psi(par,C_mark,S,strike,r,t)
C_actual = JDprice(par,S,strike,r,t);           % prezzo dato dal modello
C_market = C_mark;                              % prezzo di mercato
y = (sum(sum(C_actual - C_market).^2))          % funzione da minimizare

function y = JDprice(par,S,strike,r,t)
sigma = par(1); lambda = par(2);
jumpa = par(3); jumpb = par(4);
for i=1:5
    for j=1:31
        dc(i,j) = JD_FRFT(S,strike(j),r(i),t(i),sigma,lambda,jumpa,jumpb);
    end
end
y = dc';