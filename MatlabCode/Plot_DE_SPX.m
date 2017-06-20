clear all

sigma = 0.1970;
lambda = 0.04;
prob = 0.1;
eta1 = -0.2;
eta2 = 0.2;

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
        option(i,j) = DE_FRFT(S,strike(j),r(i),t(i),sigma,lambda,prob,eta1,eta2);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')