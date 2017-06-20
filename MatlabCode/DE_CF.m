function y = DE_CF(u, params)
% Computes the characteristic function for the Jump-Diffusion model
sigma = params(1); lambda = params(2); prob = params(3);
eta1 = params(4); eta2 = params(5); r = params(6); t = params(7);
%Kou - Double Exponential Jump-Diffusion
drift = r - 0.5*sigma^2 - lambda*(((prob*eta1)/(eta1+1))+((1-prob)*eta2/(eta2+1))-1);
y = exp(i*u*drift*t - 0.5*sigma^2*u.^2*t + t*lambda*( (prob*eta1)./(eta1+u*i) + ((1-prob)*eta2)./(eta2+u*i) - 1 ));