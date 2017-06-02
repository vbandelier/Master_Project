model = model3;

Model_name  = model.name;
Model_param = model.param;

model  = Model(Model_name,Model_param);
Noptions = size(Data,1);

Pmodel = NaN(Noptions,1);
for i = 1:Noptions
    K  = Data(i,2);
    T  = Data(i,3);
    r  = Data(i,4);
    q  = Data(i,5);
    Opt_type = Data(i,6);
    
    method = Method('Conv',[1, 1000, -Opt_type]);
    gain_fun = @(S,K) max(Opt_type*(S-K),0);
    
    option = Option(S0,r,q,K,T,1,gain_fun,@(S,K) 0.*S,0,1000,'F',1); 

    Pmodel(i) = Price(option,model,method);
end
%%
P = Data(:,1);
K = Data(:,2);
T = Data(:,3);
T_unique = unique(T);
figure
scatter3(K,T,P,'r','marker','o')
hold on
scatter3(K,T,Pmodel,'b','marker','*')
view(-5,30)
xlabel('Moneyness S/K')
ylabel('Maturities T')
zlabel('Prices')
title('Calibration of the model')
