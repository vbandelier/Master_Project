function Value = MertonSerie(S, K, r, T, sigma, lambda, jumpa, jumpb, MaxIter)

Value = 0;
lambdabis = lambda*exp(jumpa + 0.5*jumpb^2);

for i = 0:MaxIter
    Vi = sqrt(sigma^2 + (i*jumpb^2)/T);
    ri = r + (i/T)*(jumpa+0.5*jumpb^2)-lambda*(exp(jumpa+0.5*jumpb^2)-1);
    Value = Value + (exp(-lambdabis * T) * (lambdabis * T) ^ i / factorial(i)) * bs(S, K, ri, Vi, T);
end

function call = bs(S, K, r, sigma, t)
d1 = ( log(S./K)+( r + .5*sigma.^2 ).*t ) ./ sigma./sqrt(t);
d2 = d1 - sigma.*sqrt(t); n1 = normcdf(d1); n2 = normcdf(d2);
call = S.*n1 - K.*n2.*exp(-r.*t);