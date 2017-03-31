clear
clc

S0 = 100;
r = 0.01;
q = 0.03;
sigma = 0.2;
T = 1;

alpha = 1;
N = 2^12;
lambda = 0.01; % strike spacing
eta = 2*pi/(N*lambda); % u spacing

u = (0:N-1)*eta;
k0 = -N*lambda/2;
k = k0 + (0:N-1)*lambda;

phi = @(u) exp(1i*u*(r-q-0.5*sigma^2)*T-0.5*sigma^2*u.^2*T);

psi = phi(u-1i*(alpha+1))./((1i*u+alpha).*(1i*u+alpha+1));

z = exp(-1i*k0*u).*psi*eta;
z(1) = 0.5*z(1); z(end) = 0.5*z(end);
w = fft(z);
y = exp(-alpha*k).*real(w)/pi;

K = (S0 * exp(k));
Y = (exp(-r*T)*S0*y);

Price = interp1(K,Y,100);
[Call,Put]=blsprice(S0,100,r,T,sigma,q);