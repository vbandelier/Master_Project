function Plot_VG_NDX_75(sigma,theta,nu)

% sigma = 0.23065153252436;
% theta = -0.70197610213548;
% nu = 0.08440167872024;

% We load all the option data:
S = 1725.52;
strike = [1400 1425 1450 1475 1500 1525 1550 1575 1600 1625 1650 1675 1700 1725 1750 1775 1800 1825 1850 1875 1900 1925];
C_mark = [343.40 321.10 298.90 277.20 255.90 235.15 215.05 195.10 176.55 158.35 140.95 124.45 108.95 94.35 80.80 68.20 57.20 47.00 38.35 30.45 24.00 18.50];
t = 75/365;
r = 0.0244;

for i=1:22
        option(i) = VG_FRFT(S,strike(i),r,t,sigma,theta,nu);
end
option = option';


x = (sum(C_mark));
y = (sum(abs(C_mark' - option))/x)*100;
disp('The mean percentuale error per option is: ')
disp(y)

plot(strike,C_mark,'o',strike,option,'+')
axis([1375 1950 0 350]);