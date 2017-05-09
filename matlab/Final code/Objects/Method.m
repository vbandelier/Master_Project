classdef Method
    %METHOD Method definition
    % Monte Carlo, Finite Difference, Convolution methods
    
    properties
        name    % Name of the method
        param   % Method parameters
    end
    
    methods
        function obj = Method(name,param)
            if name(1) == 'M'
                obj.name = 'Monte Carlo';
            elseif name(1) == 'F'
                obj.name = 'Finite Difference';
            elseif nate(1) == 'C'
                obj.name = 'Convovolution';
            else
                obj.name = NaN;
            end
            
            obj.param = param;
        end
    end
    
end

