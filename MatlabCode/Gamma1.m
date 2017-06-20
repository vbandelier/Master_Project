function y = Gamma1(a,b)
if a == 0;
    answ = 0;
elseif a <= 1
    answ = gamma1(a);
else
    answ = gamma2(a);
end
y = answ/b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ahrens-Dieter's Gamma generator (if a<=1) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = gamma1(a)
e = exp(1);
c = (a+e)/e;
flag = 0;
while flag == 0
    U1 = rand;
    U2 = rand;
    Y = c*U1;
    if Y<=1
        Z = Y^(1/a);
        if U2<exp(-Z)
            flag = 1;
        end
    else Z = -log((c-Y)/a);
        if U2<=Z^(a-1)
            flag = 1;
        end
    end
end
y = Z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fishman (Cheng and Feast)'s Gamma generator (if a>1) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = gamma2(a)
a2 = a-1;
c = (a-(1/(6*a)))/a2;
m = 2/a2;
d = m+2;
flag = 0;
while flag == 0
    U1 = rand;
    U2 = rand;
    V = c*U2/U1;
    if m*U1-d+V+(1/V)<=0
        flag = 1;
    elseif m*log(U1)-log(V)+V-1<=0
        flag = 1;
    end
end
y = a2*V;