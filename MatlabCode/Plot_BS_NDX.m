clear all

sigma = 0.2190;

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
        option(i,j) = BS_FRFT(S,strike(j),r(i),t(i),sigma);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')