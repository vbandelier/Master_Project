function p = Price(option,model,method)
N = option.N_fixDates;
g = option.g;
gain_fun = option.gain_fun;
loss_fun = option.loss_fun;
Targ = option.Target;
K = option.K;
r = option.r;
if method.name(1) == 'M'
    M = method.param(1);
    period = option.T/option.N_fixDates;
    if model.name(1) == 'B'
        sigma = model.param(1);
        S = BS_generator(option.S0,option.r,option.q,option.T,option.N_fixDates,...
            sigma,M);
    elseif model.name(1) == 'M'
        sigma = model.param(1);
        lambda = model.param(2);
        alpha = model.param(3);
        delta = model.param(4);
        S = Merton_generator(option.S0,option.r,option.q,option.T,option.N_fixDates,...
            sigma,lambda,alpha,delta,M);
    elseif model.name(1) == 'K'
        sigma = model.param(1);
        lambda = model.param(2);
        p = model.param(3);
        eta1 = model.param(4);
        eta2 = model.param(5);
        S = Kou_generator(option.S0,option.r,option.q,option.T,option.N_fixDates,...
            sigma,lambda,p,eta1,eta2,M);
    elseif model.name(1) == 'N'
        alpha = model.param(1);
        beta = model.param(2);
        delta = model.param(3);
        S = NIG_generator(option.S0,option.r,option.q,option.T,option.N_fixDates,...
            alpha,beta,delta,M);
    elseif model.name(1) == 'V'
        theta = model.param(1);
        sigma = model.param(2);
        nu = model.param(3);
        S = VG_generator(option.S0,option.r,option.q,option.T,option.N_fixDates,...
            theta,sigma,nu,M);
    end
    V = zeros(M,1);
    for i = 1:M
        A = 0;
        t = period;
        for j = 1:N
            if( A < Targ )
                Gain = gain_fun(S(j+1,i),K);
                Loss = -g*loss_fun(S(j+1,i),K);
                A = A + Gain;
                if(A > Targ)
                    switch option.KO
                        case 'F'
                            V(i) = V(i) + exp(-r*t)*Gain;
                        case 'N'
                            break;
                        case 'P'
                            V(i) = V(i) + exp(-r*t)* (Target - (A - Gain));
                    end
                else
                    V(i) = V(i) + exp(-r*t)*(Gain+Loss);
                end
                t = t+period;
            end
        end
    end
    p = mean(V);
end



