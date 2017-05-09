classdef Option
    %OPTION Target Accrual Redemption Note definition
    properties
        S0          % Initial FX rate
        r           % Domestic risk free interest rate
        q           % Foreign risk free interest rate
        K           % Strike
        T           % Maturity
        N_fixDates  % Number of fixing dates
        gain_fun    % Gain function
        loss_fun    % Loss function
        g           % Gear factor
        Target      % Target
        KO          % KO type
    end
    
    methods
        function obj = Option(S0,r,q,K,T,N_fixDates,gain_fun,loss_fun,g,Target,KO)
            obj.S0 = S0;
            obj.r = r;
            obj.q = q;
            obj.K = K;
            obj.T = T;
            obj.N_fixDates = N_fixDates;
            obj.gain_fun = gain_fun;
            obj.loss_fun = loss_fun;
            obj.g = g;
            obj.Target = Target;
            obj.KO = KO;
        end
        
    end
    
end

