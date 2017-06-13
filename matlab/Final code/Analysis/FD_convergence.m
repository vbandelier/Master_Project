FD_BS_diff_1 = abs(N1_TARN_FD_BS.price-Nref_TARN_BS.price);
FD_BS_diff_2 = abs(N2_TARN_FD_BS.price-Nref_TARN_BS.price);
FD_BS_diff_3 = abs(N3_TARN_FD_BS.price-Nref_TARN_BS.price);
FD_BS_diff_4 = abs(N4_TARN_FD_BS.price-Nref_TARN_BS.price);
FD_BS_diff_5 = abs(N5_TARN_FD_BS.price-Nref_TARN_BS.price);

FD_Mer_diff_1 = abs(N1_TARN_FD_Mer.price-Nref_TARN_Mer.price);
FD_Mer_diff_2 = abs(N2_TARN_FD_Mer.price-Nref_TARN_Mer.price);
FD_Mer_diff_3 = abs(N3_TARN_FD_Mer.price-Nref_TARN_Mer.price);
FD_Mer_diff_4 = abs(N4_TARN_FD_Mer.price-Nref_TARN_Mer.price);
FD_Mer_diff_5 = abs(N5_TARN_FD_Mer.price-Nref_TARN_Mer.price);

FD_Kou_diff_1 = abs(N1_TARN_FD_Kou.price-Nref_TARN_Kou.price);
FD_Kou_diff_2 = abs(N2_TARN_FD_Kou.price-Nref_TARN_Kou.price);
FD_Kou_diff_3 = abs(N3_TARN_FD_Kou.price-Nref_TARN_Kou.price);
FD_Kou_diff_4 = abs(N4_TARN_FD_Kou.price-Nref_TARN_Kou.price);
FD_Kou_diff_5 = abs(N5_TARN_FD_Kou.price-Nref_TARN_Kou.price);

FD_NIG_diff_1 = abs(N1_TARN_FD_NIG.price-Nref_TARN_NIG.price);
FD_NIG_diff_2 = abs(N2_TARN_FD_NIG.price-Nref_TARN_NIG.price);
FD_NIG_diff_3 = abs(N3_TARN_FD_NIG.price-Nref_TARN_NIG.price);
FD_NIG_diff_4 = abs(N4_TARN_FD_NIG.price-Nref_TARN_NIG.price);
FD_NIG_diff_5 = abs(N5_TARN_FD_NIG.price-Nref_TARN_NIG.price);

FD_VG_diff_1 = abs(N1_TARN_FD_VG.price-Nref_TARN_VG.price);
FD_VG_diff_2 = abs(N2_TARN_FD_VG.price-Nref_TARN_VG.price);
FD_VG_diff_3 = abs(N3_TARN_FD_VG.price-Nref_TARN_VG.price);
FD_VG_diff_4 = abs(N4_TARN_FD_VG.price-Nref_TARN_VG.price);
FD_VG_diff_5 = abs(N5_TARN_FD_VG.price-Nref_TARN_VG.price);

BS_c  = [FD_BS_diff_1,...
         FD_BS_diff_2,...
         FD_BS_diff_3,...
         FD_BS_diff_4,...
         FD_BS_diff_5];
Mer_c = [FD_Mer_diff_1,...
         FD_Mer_diff_2,...
         FD_Mer_diff_3,...
         FD_Mer_diff_4,...
         FD_Mer_diff_5];
Kou_c = [FD_Kou_diff_1,...
         FD_Kou_diff_2,...
         FD_Kou_diff_3,...
         FD_Kou_diff_4,...
         FD_Kou_diff_5];
NIG_c = [FD_NIG_diff_1,...
         FD_NIG_diff_2,...
         FD_NIG_diff_3,...
         FD_NIG_diff_4,...
         FD_NIG_diff_5];
VG_c  = [FD_VG_diff_1,...
         FD_VG_diff_2,...
         FD_VG_diff_3,...
         FD_VG_diff_4,...
         FD_VG_diff_5];

x = [250,500,1000,2000,4000];
a = x/10;
t = x/50;

dx = 6./x;
da = 0.4./a;
dt = 1./(6*t);

h1 = dx + da.^4 + dt;
h2 = dx.^2 + da.^4 + dt.^2;
figure(1)
subplot(1,3,1)
loglog(x,BS_c,'-*','linewidth',1)
hold on
loglog(x,Mer_c,'-*','linewidth',1)
loglog(x,Kou_c,'-*','linewidth',1)
loglog(x,NIG_c,'-*','linewidth',1)
loglog(x,VG_c,'-*','linewidth',1)
loglog(x,h1,':k','linewidth',1)
loglog(x,h2,'-.k','linewidth',1)
xlim([x(1),x(end)])
title('\fontsize{14} No gain')
l=legend('B-S', 'Merton', 'Kou','NIG','VG','$O(h)$','$O(h^2)$');
set(l,'Interpreter','latex','FontSize',14)
xl = xlabel('$\log(N_x)$');
set(xl,'Interpreter','latex','FontSize',14)
yl = ylabel('$\log(|error|)$');
set(yl,'Interpreter','latex','FontSize',14)

FD_BS_diff_1 = abs(P1_TARN_FD_BS.price-Pref_TARN_BS.price);
FD_BS_diff_2 = abs(P2_TARN_FD_BS.price-Pref_TARN_BS.price);
FD_BS_diff_3 = abs(P3_TARN_FD_BS.price-Pref_TARN_BS.price);
FD_BS_diff_4 = abs(P4_TARN_FD_BS.price-Pref_TARN_BS.price);
FD_BS_diff_5 = abs(P5_TARN_FD_BS.price-Pref_TARN_BS.price);

FD_Mer_diff_1 = abs(P1_TARN_FD_Mer.price-Pref_TARN_Mer.price);
FD_Mer_diff_2 = abs(P2_TARN_FD_Mer.price-Pref_TARN_Mer.price);
FD_Mer_diff_3 = abs(P3_TARN_FD_Mer.price-Pref_TARN_Mer.price);
FD_Mer_diff_4 = abs(P4_TARN_FD_Mer.price-Pref_TARN_Mer.price);
FD_Mer_diff_5 = abs(P5_TARN_FD_Mer.price-Pref_TARN_Mer.price);

FD_Kou_diff_1 = abs(P1_TARN_FD_Kou.price-Pref_TARN_Kou.price);
FD_Kou_diff_2 = abs(P2_TARN_FD_Kou.price-Pref_TARN_Kou.price);
FD_Kou_diff_3 = abs(P3_TARN_FD_Kou.price-Pref_TARN_Kou.price);
FD_Kou_diff_4 = abs(P4_TARN_FD_Kou.price-Pref_TARN_Kou.price);
FD_Kou_diff_5 = abs(P5_TARN_FD_Kou.price-Pref_TARN_Kou.price);

FD_NIG_diff_1 = abs(P1_TARN_FD_NIG.price-Pref_TARN_NIG.price);
FD_NIG_diff_2 = abs(P2_TARN_FD_NIG.price-Pref_TARN_NIG.price);
FD_NIG_diff_3 = abs(P3_TARN_FD_NIG.price-Pref_TARN_NIG.price);
FD_NIG_diff_4 = abs(P4_TARN_FD_NIG.price-Pref_TARN_NIG.price);
FD_NIG_diff_5 = abs(P5_TARN_FD_NIG.price-Pref_TARN_NIG.price);

FD_VG_diff_1 = abs(P1_TARN_FD_VG.price-Pref_TARN_VG.price);
FD_VG_diff_2 = abs(P2_TARN_FD_VG.price-Pref_TARN_VG.price);
FD_VG_diff_3 = abs(P3_TARN_FD_VG.price-Pref_TARN_VG.price);
FD_VG_diff_4 = abs(P4_TARN_FD_VG.price-Pref_TARN_VG.price);
FD_VG_diff_5 = abs(P5_TARN_FD_VG.price-Pref_TARN_VG.price);

BS_c  = [FD_BS_diff_1,...
         FD_BS_diff_2,...
         FD_BS_diff_3,...
         FD_BS_diff_4,...
         FD_BS_diff_5];
Mer_c = [FD_Mer_diff_1,...
         FD_Mer_diff_2,...
         FD_Mer_diff_3,...
         FD_Mer_diff_4,...
         FD_Mer_diff_5];
Kou_c = [FD_Kou_diff_1,...
         FD_Kou_diff_2,...
         FD_Kou_diff_3,...
         FD_Kou_diff_4,...
         FD_Kou_diff_5];
NIG_c = [FD_NIG_diff_1,...
         FD_NIG_diff_2,...
         FD_NIG_diff_3,...
         FD_NIG_diff_4,...
         FD_NIG_diff_5];
VG_c  = [FD_VG_diff_1,...
         FD_VG_diff_2,...
         FD_VG_diff_3,...
         FD_VG_diff_4,...
         FD_VG_diff_5];

x = [250,500,1000,2000,4000];
a = x/10;
t = x/50;

dx = 6./x;
da = 0.4./a;
dt = 1./(6*t);

h1 = dx + da.^4 + dt;
h2 = dx.^2 + da.^4 + dt.^2;
figure(1)
subplot(1,3,2)
loglog(x,BS_c,'-*','linewidth',1)
hold on
loglog(x,Mer_c,'-*','linewidth',1)
loglog(x,Kou_c,'-*','linewidth',1)
loglog(x,NIG_c,'-*','linewidth',1)
loglog(x,VG_c,'-*','linewidth',1)
loglog(x,h1,':k','linewidth',1)
loglog(x,h2,'-.k','linewidth',1)
xlim([x(1),x(end)])
title('\fontsize{14} Part gain')
xl = xlabel('$\log(N_x)$');
set(xl,'Interpreter','latex','FontSize',14)
yl = ylabel('$\log(|error|)$');
set(yl,'Interpreter','latex','FontSize',14)

FD_BS_diff_1 = abs(F1_TARN_FD_BS.price-Fref_TARN_BS.price);
FD_BS_diff_2 = abs(F2_TARN_FD_BS.price-Fref_TARN_BS.price);
FD_BS_diff_3 = abs(F3_TARN_FD_BS.price-Fref_TARN_BS.price);
FD_BS_diff_4 = abs(F4_TARN_FD_BS.price-Fref_TARN_BS.price);
FD_BS_diff_5 = abs(F5_TARN_FD_BS.price-Fref_TARN_BS.price);

FD_Mer_diff_1 = abs(F1_TARN_FD_Mer.price-Fref_TARN_Mer.price);
FD_Mer_diff_2 = abs(F2_TARN_FD_Mer.price-Fref_TARN_Mer.price);
FD_Mer_diff_3 = abs(F3_TARN_FD_Mer.price-Fref_TARN_Mer.price);
FD_Mer_diff_4 = abs(F4_TARN_FD_Mer.price-Fref_TARN_Mer.price);
FD_Mer_diff_5 = abs(F5_TARN_FD_Mer.price-Fref_TARN_Mer.price);

FD_Kou_diff_1 = abs(F1_TARN_FD_Kou.price-Fref_TARN_Kou.price);
FD_Kou_diff_2 = abs(F2_TARN_FD_Kou.price-Fref_TARN_Kou.price);
FD_Kou_diff_3 = abs(F3_TARN_FD_Kou.price-Fref_TARN_Kou.price);
FD_Kou_diff_4 = abs(F4_TARN_FD_Kou.price-Fref_TARN_Kou.price);
FD_Kou_diff_5 = abs(F5_TARN_FD_Kou.price-Fref_TARN_Kou.price);

FD_NIG_diff_1 = abs(F1_TARN_FD_NIG.price-Fref_TARN_NIG.price);
FD_NIG_diff_2 = abs(F2_TARN_FD_NIG.price-Fref_TARN_NIG.price);
FD_NIG_diff_3 = abs(F3_TARN_FD_NIG.price-Fref_TARN_NIG.price);
FD_NIG_diff_4 = abs(F4_TARN_FD_NIG.price-Fref_TARN_NIG.price);
FD_NIG_diff_5 = abs(F5_TARN_FD_NIG.price-Fref_TARN_NIG.price);

FD_VG_diff_1 = abs(F1_TARN_FD_VG.price-Fref_TARN_VG.price);
FD_VG_diff_2 = abs(F2_TARN_FD_VG.price-Fref_TARN_VG.price);
FD_VG_diff_3 = abs(F3_TARN_FD_VG.price-Fref_TARN_VG.price);
FD_VG_diff_4 = abs(F4_TARN_FD_VG.price-Fref_TARN_VG.price);
FD_VG_diff_5 = abs(F5_TARN_FD_VG.price-Fref_TARN_VG.price);

BS_c  = [FD_BS_diff_1,...
         FD_BS_diff_2,...
         FD_BS_diff_3,...
         FD_BS_diff_4,...
         FD_BS_diff_5];
Mer_c = [FD_Mer_diff_1,...
         FD_Mer_diff_2,...
         FD_Mer_diff_3,...
         FD_Mer_diff_4,...
         FD_Mer_diff_5];
Kou_c = [FD_Kou_diff_1,...
         FD_Kou_diff_2,...
         FD_Kou_diff_3,...
         FD_Kou_diff_4,...
         FD_Kou_diff_5];
NIG_c = [FD_NIG_diff_1,...
         FD_NIG_diff_2,...
         FD_NIG_diff_3,...
         FD_NIG_diff_4,...
         FD_NIG_diff_5];
VG_c  = [FD_VG_diff_1,...
         FD_VG_diff_2,...
         FD_VG_diff_3,...
         FD_VG_diff_4,...
         FD_VG_diff_5];

x = [250,500,1000,2000,4000];
a = x/10;
t = x/50;

dx = 6./x;
da = 0.4./a;
dt = 1./(6*t);

h1 = dx + da.^4 + dt;
h2 = dx.^2 + da.^4 + dt.^2;
figure(1)
subplot(1,3,3)
loglog(x,BS_c,'-*','linewidth',1)
hold on
loglog(x,Mer_c,'-*','linewidth',1)
loglog(x,Kou_c,'-*','linewidth',1)
loglog(x,NIG_c,'-*','linewidth',1)
loglog(x,VG_c,'-*','linewidth',1)
loglog(x,h1,':k','linewidth',1)
loglog(x,h2,'-.k','linewidth',1)
xlim([x(1),x(end)])
title('\fontsize{14} Full gain')
xl = xlabel('$\log(N_x)$');
set(xl,'Interpreter','latex','FontSize',14)
yl = ylabel('$\log(|error|)$');
set(yl,'Interpreter','latex','FontSize',14)

suptitle('\fontsize{14} Finite Difference method convergence')