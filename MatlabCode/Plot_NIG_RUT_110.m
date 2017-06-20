function Plot_NIG_RUT_110(alph,beta,delta)

% alph = -18.601;
% beta = -12.247;
% delta = 0.835;

% We load all the option data:
S = 680.73;
strike = [550 560 570 580 590 600 610 620 630 640 650 660 670 680 690 700 710 720 730 740 750 760 770 780];
C_mark = [139.05 130.65 122.45 114.40 106.50 98.90 91.45 84.15 77.25 70.45 63.95 57.55 51.65 46.05 40.90 35.80 31.25 27.10 23.25 19.75 16.75 14.05 11.55 9.55];
t = 110/365;
r = 0.0082;

for i=1:24
        option(i) = NIG_FRFT(S,strike(i),r,t,delta,alph,beta);
end
option = option';


x = (sum(C_mark));
y = (sum(abs(C_mark' - option))/x)*100;
disp('The mean percentuale error per option is: ')
disp(y)

plot(strike,C_mark,'o',strike,option,'+')
axis([540 790 0 150]);