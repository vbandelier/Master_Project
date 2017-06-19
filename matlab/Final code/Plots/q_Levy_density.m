qmin = -7;
qmax = 3;

xmin = -5;
xmax = 1;

y = -7:0.01:3;

plot(y, model4.levyf(y-xmin) + model4.levyf(y-xmax),'linewidth',1)
ylim([0,0.1])
title('\fontsize{14} Lévy density centred on Xmin and Xmax')