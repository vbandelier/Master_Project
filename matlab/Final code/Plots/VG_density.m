x = -0.02:0.001:0.02;
plot(x,model5.levyf(x),'linewidth',2)
hold on
plot(x,model5.levyf_epsi(x,0.005),'--','linewidth',2)
y=get(gca,'ylim');
plot([0.005 0.005],y,':k','linewidth',2)
plot([-0.005 -0.005],y,':k','linewidth',2)

ylim([0,1e3])
l=legend('$k(y)$', '$k_{\epsilon}(y)$');
set(l,'Interpreter','latex','FontSize',16)

title('\fontsize{14} Lévy density and truncated Lévy density')