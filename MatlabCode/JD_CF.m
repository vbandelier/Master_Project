function y = JD_CF(u, params)
% Computes the characteristic function for the Jump-Diffusion model
sigma = params(1); lambda = params(2); jumpa = params(3);
jumpb = params(4); r = params(5); t = params(6);
%Merton - Gaussian Jump-Diffusion
drift = r - 0.5*sigma^2 - lambda*(exp(jumpa+0.5*jumpb^2)-1);
y = exp(i*drift*t*u - 0.5*sigma^2*u.^2*t + t*lambda*(exp(i*jumpa*u - 0.5*jumpb^2*u.^2)-1));