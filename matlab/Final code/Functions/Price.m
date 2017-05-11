function price = Price(option,model,method)
cpu_t0 = cputime;
%% Option Parameters
S0 = option.S0; r = option.r; T = option.T;
N = option.N_fixDates; g = option.g;
gain_fun = option.gain_fun;
loss_fun = option.loss_fun;
K = option.K; Targ = option.Target; KO = option.KO(1);
%% Monte Carlo Method -----------------------------------------------------
if method.name(1) == 'M'
    M = method.param(1);
    period = T/N;
    S = model.generator(option,M);
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
                    switch KO
                        case 'F'
                            V(i) = V(i) + exp(-r*t)*Gain;
                        case 'N'
                            break;
                        case 'P'
                            V(i) = V(i) + exp(-r*t)* (Targ - (A - Gain));
                    end
                else
                    V(i) = V(i) + exp(-r*t)*(Gain+Loss);
                end
                t = t+period;
            end
        end
    end
    option.set_error(std(V)/sqrt(M));
    price = mean(V);
    %% Finite Difference Method -----------------------------------------------
elseif method.name(1) == 'F'
    price = NaN;
    %% Convolution Method -----------------------------------------------------
elseif method.name(1) == 'C'
    Na = method.param(1);
    Nx = method.param(2);
    alpha = method.param(3);
    dt = T/N;
    A = linspace(0,Targ,Na);
    Xmin = -5;
    Xmax = 1;
    
    dx = (Xmax-Xmin)/Nx;
    x = Xmin + (0:Nx-1)*dx;
    du = 2*pi/(Nx*dx);
    
    phi = model.char_fun(option);
    
    u = ((0:Nx-1)-Nx/2)*du;
    y = x;
    
    w = ones(1,Nx);
    w(1) = 0.5; w(end) = 0.5;
    
    S = S0*exp(x);
    
    Q = zeros(Nx,Na);
    Qnew = Q;
    for k = 1:N
        for m = 1:Nx
            Cgtild = gain_fun(S(m),K);
            Cltild = -g*loss_fun(S(m),K);
            switch KO
                case 'F'
                    W = 1;
                case 'N'
                    W = 0;
                case 'P'
                    W = (Targ-A)/(S(m)-K);
            end
            Cgain = Cgtild .* ( ( (A+Cgtild)<Targ )+W .*( (A+Cgtild)>=Targ ) );
            Closs = Cltild .* ( ( (A+Cgtild)<Targ )+W .*( (A+Cgtild)>=Targ ) );
            Payoff = Cgain+Closs;
            Aplus  = A + Cgtild;
            Qnew(m,:) = (interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ))+Payoff;
        end
        for j = 1:Na
            % Step 1 :
            res1 = ifft((-1).^(0:Nx-1).*w.*exp(alpha*y).*Qnew(:,j)');
            
            % Step 2 :
            res2 = res1 .* phi(-(u-1i*alpha));
            
            % Step 3 :
            res3 = real(exp(-r*dt)*exp(-alpha.*x).*(-1).^(0:Nx-1).* fft(res2));
            
            Q(:,j)=res3;
        end
    end
    %%
    figure(1)
    price = interp1(S,Q(:,1),S0);
    plot(S,Q(:,1));
end
option.CPU_time = cputime-cpu_t0;
end



