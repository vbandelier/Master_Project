clear all

sigma = 0.20;
lambda = 0.03;
prob = 0.25;
eta1 = 0.80;
eta2 = 0.20;

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
        option(i,j) = DE_FRFT(S,strike(j),r(i),t(i),sigma,lambda,prob,eta1,eta2);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')