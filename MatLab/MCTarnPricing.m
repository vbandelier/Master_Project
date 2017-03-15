function [ Price ] = MCTarnPricing(S_0,X,r_d,r_f,sigma,dt,Target,N_fixDates,N_sim,gainFun,KO_type)
    S = S_0*[ones(1,N_sim);cumprod(exp((r_d-r_f-0.5*sigma^2)*dt+...
                               sigma*sqrt(dt)*randn(N_fixDates,N_sim)),1)];    
    V = 0;
    for i = 1:N_sim
        A = 0;
        t = dt;
        for j = 1:N_fixDates
            if( A < Target )
                Gain = gainFun(S(j+1,i),X);
                A = A + Gain;
                if(A > Target)
                    switch KO_type
                        case 'fullGain'
                            V = V + exp(-r_d*t)*Gain;
                        case 'noGain  '
                            break;
                        case 'partGain'
                            V = V + exp(-r_d*t)* (Target - (A - Gain));
                    end
                else
                    V = V + exp(-r_d*t)*Gain;
                end
                t = t+dt;
            end
        end
    end
    Price = V/N_sim;
end

