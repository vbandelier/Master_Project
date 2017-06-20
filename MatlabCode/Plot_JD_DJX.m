clear all

sigma = 0.19;
lambda = 0.45;
jumpa = -0.2;
jumpb = 0.02;

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
        option(i,j) = JD_FRFT(S,strike(j),r(i),t(i),sigma,lambda,jumpa,jumpb);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')