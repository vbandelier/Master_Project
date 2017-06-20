function y = pssrnd1(lambda)
% Poisson generator: exponential inter-arrival times
X = 0;
Sum = 0;
flag = 0;
while flag == 0
    E = -log(rand);
    Sum = Sum + E;
    if Sum < lambda
        X = X + 1;
    else
        flag = 1;
    end
end
y = X;