clear all

sigma = 0.25389582254892;
lambda = 0.20981842354717;
jumpa = -0.15496483442641;
jumpb = 0.24270335152332;

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
        option(i,j) = JD_FRFT(S,strike(j),r(i),t(i),sigma,lambda,jumpa,jumpb);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')