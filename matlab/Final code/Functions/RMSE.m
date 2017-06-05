function RMSE = RMSE(Model_param,Model_name, S0, Market_data,Nx)

% Computes Root Mean Squared error 
% Model_param = parameters of the model
% Model_name  = name of the model
% S0          = spot price
% Market_data = market data [obs_price,strikes,maturities,r,q,opt_type] 

Na = 1;

model  = Model(Model_name,Model_param);

Noptions = size(Market_data,1);

Error = NaN(1,Noptions);

for i = 1:Noptions
    
    obs_price = Market_data(i,1); % Observed prices
    K  = Market_data(i,2);
    T  = Market_data(i,3);
    r  = Market_data(i,4);
    q  = Market_data(i,5);
    Opt_type = Market_data(i,6);
    
    method = Method('Conv',[Na, Nx, -Opt_type]);
    gain_fun = @(S,K) max(Opt_type*(S-K),0);
    
    option = Option(S0,r,q,K,T,1,gain_fun,@(S,K) 0.*S,0,1000,'F',1); 

    price = Pricer(option,model,method); % Calculation of model option prices
    
    if ~isreal(price)
        Error(1,i) = Inf;
    elseif isnan(price)
        Error(1,i) = Inf;
    elseif price + eps < 0
        Error(1,i) = Inf;
    else
        Error(1,i) = 1/Noptions.*(price - obs_price)^2;
    end
    
end

RMSE = sqrt(sum(Error));

