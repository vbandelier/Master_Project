function NIG_FRFT

% Model parameters:
r = 0.05;       % Risk-free rate
t = 0.25;       % Time to maturity
delta = 0.1622;
alph = 6.1882;
beta = -3.8941;
S = 1;          % Initial stock price
eprice = 1;     % Strike price
% Model parameter set
params = [delta, alph, beta, r, t];

% Definition of the integration grid:
N = 128;         % Number of FFT points
a = 140;         % Upper integration bound (0,+a)
b = 0.3;         % Bounds for log-prices (-b,+b)
alpha = 2.5;     % Dampening factor (hint: 4)

% Outputs
% K : Set of strikes
% Y : Set of option prices
[K, Y] = NIG_FRFT_PRICES(S,params, N, a, b, alpha);

% We compute the option price for the given strike price by interpolation:
j=1;
while K(j)<eprice
   j=j+1;
end
option = ((Y(j)-Y(j-1))*(eprice-K(j-1)))/(K(j)-K(j-1))+Y(j-1);
fprintf('\n\nFRFT Price:\n'); fprintf('%+6.4f\n',option);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Functions that compute the program %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K, Y] = NIG_FRFT_PRICES(S, params, N, a, b, alpha)
% Parameters for the CF grid (0,a)
delta = a/N;                % Integration grid spacing
lamb = 2*b/N;               % Log-strikes grid spacing
x0 = -b;                    % First point of the log-strikes grid
eps = 0.5*delta*lamb/pi;    % Fractional parameter
% Creation of the grid
u = (0:N-1) * delta;                % Support for integration
x = x0 + (0:N-1) * lamb;            % Support for log-strikes
% Application of the rules on the grid
h = Psi_CF(u, params, alpha);       % Psi function values on the integration grid
h2 = delta * exp(-i*x0*u) .* h;     % Function to integrate
TR = [0.5 ones(1,N-2) 0.5];         % Trapezoid rule
h3 = h2 .* TR;                      % Apply rule
g = FRFT(h3, eps);                  % Application of the FRFT routine
g2 = real(exp(-alpha*x)/pi.*g);     % Recover (normalized) prices
% Compute output values
K = S * exp(x);
Y = S * g2;

function f = FRFT(x, a)
% Performs the Fractional FFT on a vector 'x' with fractional parameter 'a'
% From Chourdakis
m = size(x,2);
% Auxilliary vectors
y = zeros(1,2*m);
y(1,1:m) = x .* exp( - pi*i*a * (0:(m-1)).^2 );
z = zeros(1,2*m);
z(1,1:m) = exp( pi*i*a * (0:(m-1)).^2 );
z(1,m+1:2*m) = exp( pi*i*a * ( (m:(2*m-1)) - 2*m).^2 );
% The three (I)FFTs
fy = fft(y); fz = fft(z); fyz = fy .* fz; ifyz = ifft(fyz);
f = exp( - pi*i*a * (0:(m-1)).^2 ) .* ifyz(1,1:m);

function y = Psi_CF(u, params, a)
% computes the Psi function (modified call, see Carr-Madan, 1999)
np = length(params); t = params(np); r = params(np-1);
y1 = NIG_CF(u - i*(a+1), params);
y2 = a^2 + a - u.^2 + i*(2*a+1)*u;
y  = exp(-r*t) * y1 ./ y2;

function y = NIG_CF(u, params)
% Computes the characteristic function for the NIG model
delta = params(1); alph = params(2);
beta = params(3); r = params(4); t = params(5);
% Normal Inverse Gaussian Process
drift = r + delta*(sqrt(alph^2-(beta+1)^2)-sqrt(alph^2-beta^2));
y = exp(i*u*drift*t - delta*t*(sqrt(alph^2-(beta+i*u).^2)-sqrt(alph^2-beta^2)));