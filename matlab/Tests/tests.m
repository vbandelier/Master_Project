clear
clc

Nx = 500;
Na = 50;

S0 = 1.05;
K   = 1.0;
r_d = 0;
r_f = 0;
sigma = 0.2;
Targ = 0.9;
KO_type = 'fullGain';

N_fixDates = 20;
dt = 30/365;
T = N_fixDates*dt;

A = linspace(0,Targ,Na);

tau = sigma*sqrt(dt);
nu =(r_d-r_f-0.5*sigma^2)*dt;
Smin = S0 * exp(min((r_d-r_f-0.5*sigma^2)*T-3*sigma*T,-3*sigma*T));
Smax = S0 * exp(max((r_d-r_f-0.5*sigma^2)*T+3*sigma*T,3*sigma*T));
Xmin = log(Smin);
Xmax = log(Smax);

h = (Xmax-Xmin)/Nx;
X = Xmin + (0:Nx)*h;
S = S0*exp(X);

w = repmat([2 4],1,Nx/2);
w(1) = 1;
w = [w 1]

f = @(x,y) normpdf(x,y+nu,tau);

F = f(X',X);

% step 2 :
Q = zeros(Nx+1,Na);
Qnew = Q;
for k = 1:N_fixDates
    for m = 1:Nx+1
        Ctild = max(S(m)-K,0);
        switch KO_type
            case 'fullGain'
                W = 1;
            case 'noGain  '
                W = 0;
            case 'partGain'
                W = (Targ-A)/(S(m)-K);
        end
        C = Ctild .* ( ( (A+Ctild)<Targ )+W .*( (A+Ctild)>=Targ ) );
        Aplus  = sort(A + C);
        Qnew(m,:) = (interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ))+C;
    end
    for j = 1:Na
        Q(:,j) = exp(-r_d*dt)*h/3*(F*(w'.*Qnew(:,j)));
    end
end
%%
Price = interp1(S,Q(:,1),S0);
