x = -1:0.001:1;

param_mer = [0.0649    0.1303   -0.0584    0.1603];
model2 = Model('Mer',param_mer);
param_kou = [0.0665    0.1305    0.4    5    6];
model3 = Model('Kou',param_kou);
param_nig = [18.8491   -3.9281    0.1250];
model4 = Model('NIG',param_nig);
param_vg = [-0.0324    0.0810    0.2451];
model5 = Model('VG',param_vg);

lw=1.5;
plot(x,model2.levyf(x),'linewidth',lw)
hold on
plot(x,model3.levyf(x),'linewidth',lw)
plot(x,model4.levyf(x),'linewidth',lw)
plot(x,model5.levyf(x),'linewidth',lw)
ylim([0,0.5])