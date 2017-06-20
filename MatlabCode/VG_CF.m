function y = VG_CF(u, params)
% Computes the characteristic function for the Variance-Gamma model
sigma = params(1); theta = params(2); nu = params(3);
r = params(4); t = params(5);
% Variance Gamma Process
drift = r + log(1-theta*nu-0.5*sigma^2*nu)/nu;
y = exp(i*drift*t*u) .* ((1-i*nu*theta*u+0.5*nu*sigma^2*u.^2).^(-t/nu));