function y = BS_CF(u, params)
% Computes the characteristic function for the Black-Scholes model
sigma = params(1); r = params(2); t = params(3);
drift = r - 0.5*sigma^2;
y = exp(i*drift*t*u - 0.5*sigma^2*u.^2*t);