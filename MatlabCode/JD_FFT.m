function JD_FFT

% Model parameters:
sigma = 0.25;   % Volatility
r = 0.05;       % Risk-free rate
t = 0.25;       % Time to maturity
lambda = 0.1;   % Jump/year
jumpa = -0.05;  % Mean jump
jumpb = 0.3;    % Jump volatility
S = 1;          % Initial stock price
eprice = 1;     % Strike price
% Model parameter set
params = [sigma, lambda, jumpa, jumpb, r, t];

% Definition of the integration grid:
N = 4096;        % Number of FFT points
a = 1024;        % Upper integration bound (0,+a)
alpha = 2.5;     % Dampening factor (hint: 4)

% Outputs
% K : Set of strikes
% Y : Set of option prices
[K, Y] = JD_FFT_PRICES(S,params, N, a, alpha);

% We compute the option price for the given strike price by interpolation:
j=1;
while K(j)<eprice
   j=j+1;
end
option = ((Y(j)-Y(j-1))*(eprice-K(j-1)))/(K(j)-K(j-1))+Y(j-1);
fprintf('\n\nFFT Price:\n'); fprintf('%+6.4f\n',option);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Functions that compute the program %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K, Y] = JD_FFT_PRICES(S, params, N, a, alpha)
% Parameters for the CF grid (0,a)
delta = a/N;                % Integration grid spacing
lamb = (2*pi)/(N*delta);    % Log-strikes grid spacing
x0 = -N*lamb/2;             % First point of the log-strikes grid
% Creation of the grid
u = (0:N-1) * delta;                % Support for integration
x = x0 + (0:N-1) * lamb;     % Support for log-strikes
% Application of the rules on the grid
h = Psi_CF(u, params, alpha);       % Psi function values on the integration grid
h2 = delta * exp(-i*x0*u) .* h;     % Function to integrate
TR = [0.5 ones(1,N-2) 0.5];         % Trapezoid rule
h3 = h2 .* TR;                      % Apply rule
g = fft(h3);                        % Application of the FFT
g2 = real(exp(-alpha*x)/pi.*g);     % Recover (normalized) prices
% Compute output values
K = S * exp(x);
Y = S * g2;

function y = Psi_CF(u, params, a)
% computes the Psi function (modified call, see Carr-Madan, 1999)
np = length(params); t = params(np); r = params(np-1);
y1 = JD_CF(u - i*(a+1), params);
y2 = a^2 + a - u.^2 + i*(2*a+1)*u;
y  = exp(-r*t) * y1 ./ y2;

function y = JD_CF(u, params)
% Computes the characteristic function for the Jump-Diffusion model
sigma = params(1); lambda = params(2); jumpa = params(3);
jumpb = params(4); r = params(5); t = params(6);
%Merton - Gaussian Jump-Diffusion
drift = r - 0.5*sigma^2 - lambda*(exp(jumpa+0.5*jumpb^2)-1);
y = exp(i*drift*t*u - 0.5*sigma^2*u.^2*t + t*lambda*(exp(i*jumpa*u - 0.5*jumpb^2*u.^2)-1));