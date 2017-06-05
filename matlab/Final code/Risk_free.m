d = [1/52,2/52,3/52,1/12,2/12,3/12,4/12,6/12,9/12,1];
rd = unique(r);
rf = unique(q);
%%
subplot(2,1,1)
plot(d,rd,'-*r','linewidth',1)
xlabel('\fontsize{12} Tenor')
ylabel('\fontsize{12} Depo rate')
title('\fontsize{14} CHF risk-free rates')
set(gca,'yticklabel',num2str(get(gca, 'YTick')'),...
    'XTickLabel',{'1W','1M','2M','3M','4M','6M','9M','1Y'},...
    'XTick',[1/52,1/12,2/12,3/12,4/12,6/12,9/12,1]);
subplot(2,1,2)
plot(d,rf,'-*b','linewidth',1)
xlabel('\fontsize{12} Tenor')
ylabel('\fontsize{12} Depo rate')
title('\fontsize{14} USD risk-free rates')
set(gca,'yticklabel',num2str(get(gca, 'YTick')'),...
    'XTickLabel',{'1W','1M','2M','3M','4M','6M','9M','1Y'},...
    'XTick',[1/52,1/12,2/12,3/12,4/12,6/12,9/12,1]);