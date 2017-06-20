title('\fontsize{16} Initial price with Convolution method')
l = legend('Black-Scholes','Merton','Kou','NIG','VG')
set(l,'fontsize',14,'location','southeast')
xlabel('\fontsize{14} S')
ylabel('\fontsize{14} Price')
xlim([-0.5,3])

x = S0;
y=get(gca,'ylim');

hold on
plot([x x],y,'-.k','linewidth',1)

text(1,-11,'$S_0$','Interpreter','latex','fontsize',14)
