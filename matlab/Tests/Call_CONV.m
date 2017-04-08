clear
clc

S0 = 100;
K = 100;
r = 0.01;
q = 0.02;
sigma = 0.2;
T = 1;

alpha = 0;
N = 2^20;
L = 20*sigma*sqrt(T);
dx = L/N;
du = 2*pi/L;

mu = (r-q-0.5*sigma^2);
phi = @(u) exp(1i*u*mu*T-0.5*sigma^2*u.^2*T);

x = ((0:N-1)-N/2)*dx;
u = ((0:N-1)-N/2)*du;
y = x;

w = ones(1,N);
w(1) = 0.5; w(end) = 0.5;

V = max(S0*exp(y)-K,0);

% Step 1 :
res1 = ifft((-1).^(0:N-1).*w.*exp(alpha*y).*V);

% Step 2 :
res2 = res1 .* phi(-(u-1i*alpha));

% Step 3 :
res3 = real(exp(-alpha.*x).*(-1).^(0:N-1).* fft(res2));

plot(S0*exp(x),res3)
hold on
plot(S0*exp(x),V)
price = interp1(S0*exp(x),res3,S0);
[Call, Put] = blsprice(S0,K,r,T,sigma,q);