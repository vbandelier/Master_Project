function y = pssrnd3(lambda)
% Poisson generator: inversion by sequential search
X = 0;
Sum = exp(-lambda);
Prod = exp(-lambda);
U = rand;
while U > Sum
    X = X + 1;
    Prod = Prod*(lambda/X);
    Sum = Sum + Prod;
end
y = X;