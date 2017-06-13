Pmarket = [0.00215	0.00457	0.00720	0.01315	0.02029	0.03441	0.02397	0.01603	0.00910	0.00588	0.00281
           0.00245	0.00520	0.00818	0.01490	0.02297	0.03898	0.02776	0.01862	0.01062	0.00689	0.00331];
K_Out = [1.14042	1.08378	1.05072	1.00851	0.97937	0.94386	0.90357	0.87423	0.83291	0.80226	0.75407
         1.16571	1.09775	1.05848	1.00893	0.97521	0.93452	0.88638	0.85287	0.80563	0.77057	0.71600];
r = [-0.01227,-0.01185];

q = [0.01284,0.01360];
T = [1.5,2];

for k = 1:4
    switch k
        case 1
            model = Model('Mer',[0.0649    0.1303   -0.0584    0.1603]);
        case 2
            model = Model('Kou',[0.0665    0.1305    0.0751    3.3154    9.0490]);
        case 3
            model = Model('NIG',[18.8491   -3.9281    0.1250]);
        case 4
            model = Model('VG',[-0.0324    0.0810    0.2451]);
    end
    for i = 1:11
        for j = 1:2
            Opt_type = (delta(i)<=50)-(delta(i)>50);
            gain_fun = @(S,K) max(Opt_type*(S-K),0);
            
            option = Option(S0,r(j),q(j),K_Out(j,i),T(j),1,gain_fun,@(S,K) 0.*S,0,1000,'F',1);
            
            method = Method('Conv',[1, 1000, -Opt_type]);
            
            prices(j,i) = Pricer(option,model,method);  
        end
    end
    figure(1)
    subplot(2,2,k)
    scatter(K_Out(1,:)/S0,Pmarket(1,:),'r','marker','o')
    hold on
    scatter(K_Out(1,:)/S0,prices(1,:),'b','marker','*')
    title(model.name)
    figure(2)
    subplot(2,2,k)
    scatter(K_Out(2,:)/S0,Pmarket(2,:),'r','marker','o')
    hold on
    scatter(K_Out(2,:)/S0,prices(2,:),'b','marker','*')
    title(model.name)
end
figure(1)
suptitle('Out of sample 18M');
figure(2)
suptitle('Out of sample 2Y');