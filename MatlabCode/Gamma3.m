function y = Gamma3(a,b)
if a == 0;
    answ = 0;
elseif a <= 1
    answ = gamma1(a);
else
    answ = gamma2(a);
end
y = answ/b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Berman's Gamma generator (if a<=1) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = gamma1(a)
X = 0;
Y = 0;
while X + Y <= 1
U = rand;
V = rand;
X = U^(1/a);
    if a == 1
        Y = 1;
    else Y = V^(1/(1-a));
    end
end
U = rand;
V = rand;
y = -X*log(U*V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Best's Gamma generator (if a>1) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = gamma2(a)
d = a-1;
c = 3*a - 3/4;
ifl = 0;
while(ifl == 0)
    U = rand;
    V = rand;
    W = U*(1-U);
    Y = sqrt(c/W)*(U-0.5);
    X = d + Y;
    Z = 64*W^3*V^3;
    if(log(Z)<=2*(d*log(X/d)-Y))
        if(X>0)
            ifl = 1;
        end
    end
end
y = X;