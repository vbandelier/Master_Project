%% Gauss-Hermite Quadrature with Cubic interpolation (GHQC)
clear 
clc
%  European Option
S0 = 100;
K  = 100;
sigma = 0.2;
r = 0.07;
q = 0.03;
T = 1;

M = 300;
Ns = (1:100)*10;
 
% BLS price
[c,p] = blsprice(S0,K,r,T,sigma,q); 
price = zeros(1,10);
for i = 1:100
    N = Ns(i)
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
 
tau = sigma*sqrt(dt);
nu =(r-q-0.5*sigma^2)*dt;
 
% Step 2
Q = max(K-S,0);

for k = 1:N
% Step 3
Qint = griddedInterpolant(X,Q,'cubic');
 
% Step 4
%% q = 3 :
% xi = [-1.22474,  0,       1.22474];
% w  = [ 0.295409, 1.18164, 0.295409];

%% q = 6 :
xi = [-2.35061,  -1.33585,  -0.436077,  0.436077,   1.33585,    2.35061];
w  = [0.00453001, 0.157067,  0.72463,   0.72463,    0.157067,   0.00453001];

%% q = 10 :
% xi = [-3.43616,     -2.53273,   -1.75668,   -1.03661,   -0.342901, ...
%       0.342901,      1.03661,    1.75668,    2.53273,    3.43616];
% w  = [7.64043e-6,    0.00134365, 0.0338744,  0.240139,   0.610863, ...
%       0.610863,      0.240139,   0.0338744,  0.00134365, 7.64043e-6];

Qnew = zeros(size(Q));
for m = 1:M+1
    Qnew(m) = exp(-r*dt)/sqrt(pi) * (w*Qint(sqrt(2)*tau*xi+nu+X(m))');
end

Q = Qnew;%max(Qnew,max(K-S,0));
end

price(i) = interp1(S,Q,S0);
end

%%
plot(price)
hold on
plot(1:100,p*ones(100,1))
