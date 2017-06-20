function Plot_VG_NDX
clear all

% Model parameters:
sigma = 0.2877;
theta = -0.3002;
nu = 0.0116;

S = 1725.52;    % Spot Price
% We load market option data
OP = xlsread('NDX.xls');
TD = xlsread('NDX_T.xls');

[no,mo] = size(OP); strike = OP(:,1);
C_mark = OP(:,2:mo); [no,mo] = size(C_mark);
t = (1/365)*TD(:,1); r = TD(:,2);

for i=1:mo
    for j=1:no
        option(i,j) = VG_FRFT(S,strike(j),r(i),t(i),sigma,theta,nu);
    end
end
option = option';

format short
disp(C_mark)
disp(option)

% We plot both market and model prices
plot(strike,C_mark,'o',strike,option,'*')