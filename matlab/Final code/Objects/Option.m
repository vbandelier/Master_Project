classdef Option < handle
    %OPTION Target Accrual Redemption Note definition
    properties
        S0          % Initial FX rate
        r           % Domestic risk free interest rate
        q           % Foreign risk free interest rate
        K           % Strike
        Period      % Period between fixing dates
        N_fixDates  % Number of fixing dates
        gain_fun    % Gain function
        loss_fun    % Loss function
        g           % Gear factor
        Target      % Target
        KO          % KO type
        
        price       % Price of the option
        error       % Price error
        CPU_time    % Computing time
    end
    
    methods
        function obj = Option(S0,r,q,K,Period,N_fixDates,gain_fun,loss_fun,g,Target,KO)
            obj.S0 = S0;
            obj.r = r;
            obj.q = q;
            obj.K = K;
            obj.Period = Period;
            obj.N_fixDates = N_fixDates;
            obj.gain_fun = gain_fun;
            obj.loss_fun = loss_fun;
            obj.g = g;
            obj.Target = Target;
            if KO(1) == 'N'
                obj.KO = 'No gain';
            elseif KO(1) == 'P'
                obj.KO = 'Part gain';
            elseif KO(1) == 'F'
                obj.KO = 'Full gain';
            end
        end
        
        function set_price(option,model,method)
            option.price = Price(option,model,method);
        end
        function set_error(option,err)
            option.error = err;
        end
    end
    
end

