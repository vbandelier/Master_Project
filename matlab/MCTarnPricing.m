function [ Price,stdev ] = MCTarnPricing(S0,K,r_d,r_f,sigma,period,Target,N_fixDates,N_sim,gainFun,lossFun,g,KO_type)
S = S0*[ones(1,N_sim);cumprod(exp((r_d-r_f-0.5*sigma^2)*period+...
    sigma*sqrt(period)*randn(N_fixDates,N_sim)),1)];
V = zeros(N_sim,1);
for i = 1:N_sim
    A = 0;
    t = period;
    for j = 1:N_fixDates
        if( A < Target )
            Gain = gainFun(S(j+1,i),K);
            Loss = -g*lossFun(S(j+1,i),K);
            A = A + Gain;
            if(A > Target)
                switch KO_type
                    case 'fullGain'
                        V(i) = V(i) + exp(-r_d*t)*Gain;
                    case 'noGain  '
                        break;
                    case 'partGain'
                        V(i) = V(i) + exp(-r_d*t)* (Target - (A - Gain));
                end
            else
                V(i) = V(i) + exp(-r_d*t)*(Gain+Loss);
            end
            t = t+period;
        end
    end
end
Price = mean(V);
stdev = std(V);
end

