clear all

alph = 20;
beta = -9;
delta = 0.79;

S = 122.22;
OP = xlsread('DJX.xls');
TD = xlsread('DJX_T.xls');

[no,mo] = size(OP);
strike = OP(:,1);
C_mark = OP(:,2:mo);
[no,mo] = size(C_mark);
t = (1/365)*TD(:,1);
r = TD(:,2);

for i=1:mo
    for j=1:no
        option(i,j) = NIG_FRFT(S,strike(j),r(i),t(i),delta,alph,beta);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'+')