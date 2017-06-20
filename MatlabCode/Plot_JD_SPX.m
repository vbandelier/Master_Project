clear all

sigma = 0.21480472238442;
lambda = 0.15166930934461;
jumpa = -0.20021206447565;
jumpb = 0.19937798420652;

S = 1327.16;
OP = xlsread('SPX.xls');
TD = xlsread('SPX_T.xls');

[no,mo] = size(OP);
strike = OP(:,1);
C_mark = OP(:,2:mo);
[no,mo] = size(C_mark);
t = (1/365)*TD(:,1);
r = TD(:,2);

for i=1:mo
    for j=1:no
        option(i,j) = JD_FRFT(S,strike(j),r(i),t(i),sigma,lambda,jumpa,jumpb);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')