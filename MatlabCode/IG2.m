%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Algorithm from Glasserman  %%%
%%% Michael, Schucany and Hass %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = IG2(a,b)
C = 1/b;
D = C*a;
D = D*D;
Norm = randn;
V = Norm*Norm;
eps = C*V;
Y = C*(a+(eps/2) + sqrt(eps*(a+(eps/4))));
p = a/(a+b*Y);
U = rand;
if U > p
    Y = D/Y;
end
y = Y;