
Model_name  = 'BS';
Model_param = param_bs;

model  = Model(Model_name,Model_param);
Noptions = size(Data,1);

Pmodel = NaN(Noptions,1);
for i = 1:Noptions
    K  = Data(i,2);
    T  = Data(i,3);
    r  = Data(i,4)/100;
    q  = Data(i,5)/100;
    Opt_type = Data(i,6);
    
    method = Method('Conv',[1, 500, -Opt_type]);
    gain_fun = @(S,K) max(Opt_type*(S-K),0);
    
    option = Option(S0,r,q,K,T,1,gain_fun,@(S,K) 0.*S,0,1000,'F'); 

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
xlabel('Strike K')
ylabel('Maturities T')
zlabel('Prices')
title('Calibration of the model')

S0  = 1.0962;
disp(RMSE(Model_param,Model_name, S0, Data))