%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Algorithm from Devroye %%%%%
%%% Michael, Schucany and Hass %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = IG1(a,b)
N = randn;
Y = N*N;
X1 = (a/b) + Y/(2*b*b) - (sqrt(4*a*b*Y + Y*Y))/(2*b*b);
U = rand;
if U <= (a/(a+X1*b))
    X = X1;
else X = (a*a)/(b*b*X1);
end
y = X;