K = 100;

f = @(x) max(x-K,0);

phi = fourier(f);