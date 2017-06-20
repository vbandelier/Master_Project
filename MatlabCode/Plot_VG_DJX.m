clear all

sigma = 0.17;
theta = -0.35;
nu = 0.22;

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
        option(i,j) = VG_FRFT(S,strike(j),r(i),t(i),sigma,theta,nu);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

plot(strike,C_mark,'o',strike,option,'*')