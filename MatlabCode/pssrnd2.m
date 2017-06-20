function y = pssrnd2(lambda)
% Poisson generator: multiplication of uniform r.v.
X = 0;
Prod = 1;
EE = exp(-lambda);
flag = 0;
while flag == 0
    U = rand;
    Prod = Prod*U;
    if Prod > EE
        X = X + 1;
    else
        flag = 1;
    end
end
y = X;