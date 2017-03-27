clear
clc

T = 0.1;
S0 = 100;
r = 0.1;
q = 0;
sigma = 0.25;
K = 90;

[call, ~] = blsprice(S0,K,r,T,sigma,q);

N = 2^7;
alpha = 0;

L = 6;
dy = L/N;
du = 2*pi/L;
u = ((0:N-1)-N/2)*du;
y = log(K/S0)+((0:N-1)-L/2)*dy;
x = ((0:N-1)-L/2)*dy;

w = ones(N,1);
w(1) = 0.5;
w(end) = 0.5;

v = exp(alpha*x).*max(exp(y)-K,0);

n = (0:N-1);

fun1 = (-1).^n * w * v;

vec1 = exp(-1i*(0:N-1).*n*2*pi/N);
