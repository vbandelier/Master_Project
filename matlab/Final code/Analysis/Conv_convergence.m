Conv_BS_diff_1 = abs(TARN_Conv_BS_025P.price-TARN_Conv_BS_ExP.price);
Conv_BS_diff_2 = abs(TARN_Conv_BS_050P.price-TARN_Conv_BS_ExP.price);
Conv_BS_diff_3 = abs(TARN_Conv_BS_100P.price-TARN_Conv_BS_ExP.price);
Conv_BS_diff_4 = abs(TARN_Conv_BS_200P.price-TARN_Conv_BS_ExP.price);
Conv_BS_diff_5 = abs(TARN_Conv_BS_400P.price-TARN_Conv_BS_ExP.price);
Conv_BS_diff_6 = abs(TARN_Conv_BS_800P.price-TARN_Conv_BS_ExP.price);

Conv_Mer_diff_1 = abs(TARN_Conv_Mer_025P.price-TARN_Conv_Mer_ExP.price);
Conv_Mer_diff_2 = abs(TARN_Conv_Mer_050P.price-TARN_Conv_Mer_ExP.price);
Conv_Mer_diff_3 = abs(TARN_Conv_Mer_100P.price-TARN_Conv_Mer_ExP.price);
Conv_Mer_diff_4 = abs(TARN_Conv_Mer_200P.price-TARN_Conv_Mer_ExP.price);
Conv_Mer_diff_5 = abs(TARN_Conv_Mer_400P.price-TARN_Conv_Mer_ExP.price);
Conv_Mer_diff_6 = abs(TARN_Conv_Mer_800P.price-TARN_Conv_Mer_ExP.price);

Conv_Kou_diff_1 = abs(TARN_Conv_Kou_025P.price-TARN_Conv_Kou_ExP.price);
Conv_Kou_diff_2 = abs(TARN_Conv_Kou_050P.price-TARN_Conv_Kou_ExP.price);
Conv_Kou_diff_3 = abs(TARN_Conv_Kou_100P.price-TARN_Conv_Kou_ExP.price);
Conv_Kou_diff_4 = abs(TARN_Conv_Kou_200P.price-TARN_Conv_Kou_ExP.price);
Conv_Kou_diff_5 = abs(TARN_Conv_Kou_400P.price-TARN_Conv_Kou_ExP.price);
Conv_Kou_diff_6 = abs(TARN_Conv_Kou_800P.price-TARN_Conv_Kou_ExP.price);

Conv_NIG_diff_1 = abs(TARN_Conv_NIG_025P.price-TARN_Conv_NIG_ExP.price);
Conv_NIG_diff_2 = abs(TARN_Conv_NIG_050P.price-TARN_Conv_NIG_ExP.price);
Conv_NIG_diff_3 = abs(TARN_Conv_NIG_100P.price-TARN_Conv_NIG_ExP.price);
Conv_NIG_diff_4 = abs(TARN_Conv_NIG_200P.price-TARN_Conv_NIG_ExP.price);
Conv_NIG_diff_5 = abs(TARN_Conv_NIG_400P.price-TARN_Conv_NIG_ExP.price);
Conv_NIG_diff_6 = abs(TARN_Conv_NIG_800P.price-TARN_Conv_NIG_ExP.price);

Conv_VG_diff_1 = abs(TARN_Conv_VG_025P.price-TARN_Conv_VG_ExP.price);
Conv_VG_diff_2 = abs(TARN_Conv_VG_050P.price-TARN_Conv_VG_ExP.price);
Conv_VG_diff_3 = abs(TARN_Conv_VG_100P.price-TARN_Conv_VG_ExP.price);
Conv_VG_diff_4 = abs(TARN_Conv_VG_200P.price-TARN_Conv_VG_ExP.price);
Conv_VG_diff_5 = abs(TARN_Conv_VG_400P.price-TARN_Conv_VG_ExP.price);
Conv_VG_diff_6 = abs(TARN_Conv_VG_800P.price-TARN_Conv_VG_ExP.price);

BS_c  = [Conv_BS_diff_1,...
         Conv_BS_diff_2,...
         Conv_BS_diff_3,...
         Conv_BS_diff_4,...
         Conv_BS_diff_5,...
         Conv_BS_diff_6];
Mer_c = [Conv_Mer_diff_1,...
         Conv_Mer_diff_2,...
         Conv_Mer_diff_3,...
         Conv_Mer_diff_4,...
         Conv_Mer_diff_5,...
         Conv_Mer_diff_6];
Kou_c = [Conv_Kou_diff_1,...
         Conv_Kou_diff_2,...
         Conv_Kou_diff_3,...
         Conv_Kou_diff_4,...
         Conv_Kou_diff_5,...
         Conv_Kou_diff_6];
NIG_c = [Conv_NIG_diff_1,...
         Conv_NIG_diff_2,...
         Conv_NIG_diff_3,...
         Conv_NIG_diff_4,...
         Conv_NIG_diff_5,...
         Conv_NIG_diff_6];
VG_c  = [Conv_VG_diff_1,...
         Conv_VG_diff_2,...
         Conv_VG_diff_3,...
         Conv_VG_diff_4,...
         Conv_VG_diff_5,...
         Conv_VG_diff_6];

x = [250,500,1000,2000,4000,8000];
a = x/10;

dx = 6./x;
da = 0.4./x;

h1 = dx + da.^4;
h2 = dx.^2 + da.^4;

loglog(x,BS_c,'-*','linewidth',1)
hold on
loglog(x,Mer_c,'-*','linewidth',1)
loglog(x,Kou_c,'-*','linewidth',1)
loglog(x,NIG_c,'-*','linewidth',1)
loglog(x,VG_c,'-*','linewidth',1)
loglog(x,h1,':k','linewidth',1)
loglog(x,h2,'-.k','linewidth',1)
xlim([x(1),x(end)])

