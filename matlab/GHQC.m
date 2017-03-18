%% Gauss-Hermite Quadrature with Cubic interpolation (GHQC)
clear 
clc
%  European Option
S0 = 40;
K  = 40;
sigma = 0.2;
r = 0.06;
q = 0;
T = 1;
 
M = 100;
N = 50;
 
% BLS price
[c,p] = blsprice(S0,K,r,T,sigma,q); 

% Step 1
Smin = S0 * exp(-5*sigma*sqrt(T));
Smax = S0 * exp(5*sigma*sqrt(T));

Xmin = log(Smin/S0);
Xmax = log(Smax/S0);

h = (Xmax-Xmin)/M;
X = Xmin + (0:M)*h;
S = S0*exp(X);
dt = T/N; 
t = (0:N)*dt;
 
tau = (r-q-0.5*sigma^2)*dt;
nu = sigma*sqrt(dt);
 
% Step 2
Q = max(K-S,0);

for k = 1:N
% Step 3
Qint = griddedInterpolant(X,Q,'spline');
 
% Step 4
xi = [-2.35061,  -1.33585, -0.436077, 0.436077, 1.33585,  2.35061];
w  = [0.00453001, 0.157067, 0.72463,  0.72463,  0.157067, 0.00453001];

Qnew = zeros(size(Q));
for m = 1:M+1
    Qnew(m) = exp(-r*dt)/sqrt(pi) * (w*Qint(tau*xi+nu+X(m))');
end
 
Q = max(Qnew,max(S-K,0));
end

price = interp1(S,Q,S0);
