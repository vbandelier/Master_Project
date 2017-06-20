clear all

alph = -18.4;
beta = -8.5;
delta = 1.195;

S = 1725.52;
OP = xlsread('NDX.xls');
TD = xlsread('NDX_T.xls');

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

plot(strike,C_mark,'o',strike,option,'*')