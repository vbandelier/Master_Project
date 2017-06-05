%% Merton model
% Parameters
lambda = 5;     % jump intensity
sigma1 = 0.3;   % diffusion volatility
mu = 0;         % mean jump size
delta = 1;      % standard deviation of jump size

% Levy density
x = -5:0.01:5;
y = lambda * normpdf(x,mu,delta);

figure(2)
subplot(1,2,1)
plot(x,y,'linewidth',1)
title('\fontsize{14} Merton : Lévy density')

%% VG model
% Parameters
theta = 0;   % drift of the Brownian motion
sigma2= 1;    % volatility of the Brownaian motion
kappa = 1;    % variance of the subordinator

A = theta/sigma2^2;
B = sqrt(theta^+2*sigma2^2/kappa)/sigma2^2;

y = 1./(kappa*abs(x)).*exp(A*x-B*abs(x));

subplot(1,2,2)
plot(x,y,'linewidth',1)
ylim([0 10])
title('\fontsize{14} Variance Gamma : Lévy density')