clear all

sigma = 0.26537718516003;
lambda = 0.01307205902283;
prob = 0.09923809404993;
eta1 = -0.29971371641178;
eta2 = 0.30104784129891;

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
        option(i,j) = DE_FRFT(S,strike(j),r(i),t(i),sigma,lambda,prob,eta1,eta2);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')