classdef Method
    %METHOD Method definition
    % Monte Carlo, Finite Difference, Convolution methods
    
    properties
        name    % Name of the method
        param   % Method parameters
    end
    
    methods
        function method = Method(name,param)
            if name(1) == 'M'
                method.name = 'Monte Carlo';
            elseif name(1) == 'F'
                method.name = 'Finite Difference';
            elseif name(1) == 'C'
                method.name = 'Convovolution';
            else
                method.name = NaN;
            end
            method.param = param;
        end
    end
    
end

