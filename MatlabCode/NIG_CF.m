function y = NIG_CF(u, params)
% Computes the characteristic function for the NIG model
delta = params(1); alph = params(2);
beta = params(3); r = params(4); t = params(5);
% Normal Inverse Gaussian Process
drift = r + delta*(sqrt(alph^2-(beta+1)^2)-sqrt(alph^2-beta^2));
y = exp(i*u*drift*t - delta*t*(sqrt(alph^2-(beta+i*u).^2)-sqrt(alph^2-beta^2)));