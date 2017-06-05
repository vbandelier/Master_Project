FD_BS_diff_1 = abs(TARN_FD_BS_025F.price-TARN_Conv_BS_ExF.price);
FD_BS_diff_2 = abs(TARN_FD_BS_050F.price-TARN_Conv_BS_ExF.price);
FD_BS_diff_3 = abs(TARN_FD_BS_100F.price-TARN_Conv_BS_ExF.price);
FD_BS_diff_4 = abs(TARN_FD_BS_200F.price-TARN_Conv_BS_ExF.price);

FD_Mer_diff_1 = abs(TARN_FD_Mer_025F.price-TARN_Conv_BS_ExF.price);
FD_Mer_diff_2 = abs(TARN_FD_Mer_050F.price-TARN_Conv_BS_ExF.price);
FD_Mer_diff_3 = abs(TARN_FD_Mer_100F.price-TARN_Conv_BS_ExF.price);
FD_Mer_diff_4 = abs(TARN_FD_Mer_200F.price-TARN_Conv_BS_ExF.price);

FD_Kou_diff_1 = abs(TARN_FD_Kou_025F.price-TARN_Conv_Kou_ExF.price);
FD_Kou_diff_2 = abs(TARN_FD_Kou_050F.price-TARN_Conv_Kou_ExF.price);
FD_Kou_diff_3 = abs(TARN_FD_Kou_100F.price-TARN_Conv_Kou_ExF.price);
FD_Kou_diff_4 = abs(TARN_FD_Kou_200F.price-TARN_Conv_Kou_ExF.price);

FD_NIG_diff_1 = abs(TARN_FD_NIG_025F.price-TARN_Conv_NIG_ExF.price);
FD_NIG_diff_2 = abs(TARN_FD_NIG_050F.price-TARN_Conv_NIG_ExF.price);
FD_NIG_diff_3 = abs(TARN_FD_NIG_100F.price-TARN_Conv_NIG_ExF.price);
FD_NIG_diff_4 = abs(TARN_FD_NIG_200F.price-TARN_Conv_NIG_ExF.price);

FD_VG_diff_1 = abs(TARN_FD_VG_025F.price-TARN_Conv_VG_ExF.price);
FD_VG_diff_2 = abs(TARN_FD_VG_050F.price-TARN_Conv_VG_ExF.price);
FD_VG_diff_3 = abs(TARN_FD_VG_100F.price-TARN_Conv_VG_ExF.price);
FD_VG_diff_4 = abs(TARN_FD_VG_200F.price-TARN_Conv_VG_ExF.price);

BS_c  = [FD_BS_diff_1,FD_BS_diff_2,FD_BS_diff_3,FD_BS_diff_4];
Mer_c = [FD_Mer_diff_1,FD_Mer_diff_2,FD_Mer_diff_3,FD_Mer_diff_4];
Kou_c = [FD_Kou_diff_1,FD_Kou_diff_2,FD_Kou_diff_3,FD_Kou_diff_4];
NIG_c = [FD_NIG_diff_1,FD_NIG_diff_2,FD_NIG_diff_3,FD_NIG_diff_4];
VG_c  = [FD_VG_diff_1,FD_VG_diff_2,FD_VG_diff_3,FD_VG_diff_4];

x = [250,500,1000,2000];
a = x/10;
t = x/50;

dx = 6./x;
da = 0.4./x;
dt = 1./(t*12);

h1 = dx + da.^4 + dt;
h2 = dx.^2 + da.^4 + dt.^2;

loglog(x,BS_c,'-*','linewidth',1)
hold on
loglog(x,Mer_c,'-*','linewidth',1)
loglog(x,Kou_c,'-*','linewidth',1)
loglog(x,NIG_c,'-*','linewidth',1)
loglog(x,VG_c,'-*','linewidth',1)
loglog(x,h1,':k','linewidth',1)
loglog(x,h2,'-.k','linewidth',1)
xlim([x(1),x(end)])

