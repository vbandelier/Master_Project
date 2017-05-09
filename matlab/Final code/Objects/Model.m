classdef Model
    %MODEL Model definition
    % Black-Scholes, Merton, Kou, NIG, VG
    
    properties
        name    % Name of the model
        param   % Vector of parameters
    end
    
    methods
        function obj = Model(name,param)
           if name(1) == 'B'
               obj.name = 'Black-Scholes';
           elseif name(1) == 'M'
               obj.name = 'Merton';
           elseif name(1) == 'K'
               obj.name = 'Kou';
           elseif name(1) == 'N'
               obj.name = 'Normal Inverse Gaussian';
           elseif name(1) == 'V'
               obj.name = 'Variance Gamma';
           else
               obj.name = NaN;
           end
           obj.param = param;
        end
    end
end

