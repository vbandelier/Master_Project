function price = Pricer(option,model,method)
cpu_t0 = cputime;
%% Option Parameters
S0 = option.S0; r = option.r; q = option.q; N = option.N_fixDates;
g = option.g; gain_fun = option.gain_fun;
loss_fun = option.loss_fun;
K = option.K; Targ = option.Target; KO = option.KO(1);
period = option.Period; T = period*N; ApF = option.ApF;

if length(K) == 1
    K = K*ones(N,1);
end

Xmin = -5;
Xmax = 1;
q_min = -7;
q_max = 3;
q_inf = 10;
epsi = 0.05;
tol = 0.0001;
fix_pt_iter = 200;
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
                Gain = gain_fun(S(j+1,i),K(end-j+1));
                Loss = -g*loss_fun(S(j+1,i),K(end-j+1));
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
    option.set_error(std(ApF*V)/sqrt(M-1));
    price = mean(V);
    %% Finite Difference Method -----------------------------------------------
elseif method.name(1) == 'F'
    Na = method.param(1);
    Nx = method.param(2);
    Nt = method.param(3);
    if Na > 1
        A = linspace(0,Targ,Na);
    else
        A = 0;
    end
    dt = period/Nt;
    dx = (Xmax-Xmin)/Nx;
    FD_grid = Xmin:dx:Xmax;
    inner_grid = FD_grid(2:end-1);
    S = S0*exp(FD_grid);
    
    Cgtild = @(s,k) gain_fun(s,k);
    Cltild = @(s,k)-g*loss_fun(s,k);
    switch KO
        case 'F'
            W = @(s,a,k) 1*ones(size(a));
        case 'N'
            W = @(s,a,k) 0*ones(size(a));
        case 'P'
            W = @(s,a,k) (Targ-a)./(s-k);
    end
    Cgain = @(s,a,k) Cgtild(s,k) .* ( ( (a+Cgtild(s,k))<Targ )+W(s,a,k) .*( (a+Cgtild(s,k))>=Targ ) );
    Closs = @(s,a,k) Cltild(s,k) .* ( ( (a+Cgtild(s,k))<Targ )+W(s,a,k) .*( (a+Cgtild(s,k))>=Targ ) );
    Payoff_fun = @(s,a,k)Cgain(s,a,k)+Closs(s,a,k);
    ext_fun = @(x,a,k,t,kk) Cgain(S0*exp(x+(r-q)*t),a,k)*exp(-r*t) + exp(-r*t)*sum(cell2mat(arrayfun(@(j) Closs(S0*exp(x+(r-q)*(j*period+t)),a,k)*exp(-r*j*period),0:(kk-1),'UniformOutput',0)'),1);
%         Closs(S0*exp(x+(r-q)*t),a,k)*exp(-r*t)*(exp(r*(1-kk)*period)-exp(r*period))/(1-exp(r*period));
    
    quad_grid_right = Xmax + (0:dx:(q_max-Xmax));
    quad_grid_left = fliplr(Xmin - (0:dx:(Xmin-q_min)));
    quad_grid = [quad_grid_left, inner_grid, quad_grid_right];
    Nq = length(quad_grid)-1;
    
    sigma2 = model.get_sigma2_FD(epsi);
    lambda = model.get_lambda_FD(epsi,q_inf);
    c = model.get_c_FD(epsi,q_inf);
    
    aa_up   = -0.5*sigma2*ones(Nx-2,1)/(dx^2);
    aa_main =  0.5*sigma2*2*ones(Nx-1,1)/(dx^2);
    aa_down = -0.5*sigma2*ones(Nx-2,1)/(dx^2);
    
    bb_up   = -(r-q-0.5*sigma2-c)*ones(Nx-2,1)/(2*dx);
    bb_down =  (r-q-0.5*sigma2-c)*ones(Nx-2,1)/(2*dx);
    
    cc_main =  (r + lambda)*ones(Nx-1,1);
    
    B_up   = dt*(aa_up  +bb_up);
    B_main = dt*(aa_main+cc_main)+ones(Nx-1,1);
    B_down = dt*(aa_down+bb_down);
    
    levy_grid = (quad_grid(1)-inner_grid(end)):dx:(quad_grid(end)-inner_grid(1));
    if model.name(1) == 'B' || model.name(1) == 'M' || model.name(1) == 'K'
        levyf_vals= model.levyf(levy_grid);
    elseif model.name(1) == 'N' || model.name(1) == 'V'
        levyf_vals= model.levyf_epsi(levy_grid,epsi);
    end
    fftJ = fft(dx*levyf_vals);
    
    U = zeros(Nx+1,Na);
    Unew = U;
    for kk = 1:N
        
        for m = 1:Nx+1
            Payoff = Payoff_fun(S(m),A,K(end-kk+1));
            Aplus  = A + Cgtild(S(m),K(end-kk+1));
            if Na>1
                Unew(m,:) = (interp1(A,U(m,:),Aplus,'spline').*(Aplus<Targ))+Payoff;
            else
                Unew(m) = Payoff;
            end
        end
        for j = 1:Na
            V = zeros(length(FD_grid),Nt+1);
            V(:,1) = Unew(:,j);
            for tn = 1:Nt
                tnew = tn*dt;
                Vleft = ext_fun(quad_grid_left,A(j),K(end-kk+1),tnew,kk);
                Vright= ext_fun(quad_grid_right,A(j),K(end-kk+1),tnew,kk);
                iter = 0;
                Vstar = [Vleft, V(2:end-1,tn)', Vright];
                Vstar_old = 0*Vstar;
                while max(abs(Vstar_old-Vstar))>tol && iter<fix_pt_iter
                    iter = iter + 1;
                    fnew = zeros(size(inner_grid))';
                    fnew(1)  = 0.5*sigma2*ext_fun(Xmin,A(j),K(end-kk+1),tnew,kk)/(dx^2)...
                        - (r-q-0.5*sigma2-c)*ext_fun(Xmin,A(j),K(end-kk+1),tnew,kk)/(2*dx);
                    fnew(end)= 0.5*sigma2*ext_fun(Xmax,A(j),K(end-kk+1),tnew,kk)/(dx^2)...
                        + (r-q-0.5*sigma2-c)*ext_fun(Xmax,A(j),K(end-kk+1),tnew,kk)/(2*dx);
                    fftV = fft([zeros(1,length(levy_grid)-Nq-1), Vstar]);
                    fcomp = ifft(conj(fftJ).*fftV);
                    fnew = fnew + fcomp(1:Nx-1)';
                    ftot = V(2:end-1,tn) + dt*fnew;
                    
                    B = sparse(1:Nx-2,2:Nx-1,B_up,Nx-1,Nx-1) + ...
                        sparse(1:Nx-1,1:Nx-1,B_main,Nx-1,Nx-1)+...
                        sparse(2:Nx-1,1:Nx-2,B_down,Nx-1,Nx-1);
                    
                    sol = B\ftot;
                    
                    Vstar_old = Vstar;
                    Vstar=[Vleft,  sol',  Vright];
                end
                V(:,tn+1)=[ext_fun(Xmin,A(j),K(end-kk+1),tnew,kk); sol; ext_fun(Xmax,A(j),K(end-kk+1),tnew,kk)];
            end
            U(:,j) = V(:,end);
        end
    end
    price = interp1(S,U(:,1),S0);
    option.set_error(NaN);
    plot(S,U(:,1),'linewidth',1);
    %% Convolution Method -----------------------------------------------------
elseif method.name(1) == 'C'
    Na = method.param(1);
    Nx = method.param(2);
    alpha = method.param(3);
    dt = T/N;
    if Na > 1
        A = linspace(0,Targ,Na);
    else
        A = 0;
    end
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
            Cgtild = gain_fun(S(m),K(end-k+1));
            Cltild = -g*loss_fun(S(m),K(end-k+1));
            switch KO
                case 'F'
                    W = 1;
                case 'N'
                    W = 0;
                case 'P'
                    W = (Targ-A)/(S(m)-K(end-k+1));
            end
            Cgain = Cgtild .* ( ( (A+Cgtild)<Targ )+W .*( (A+Cgtild)>=Targ ) );
            Closs = Cltild .* ( ( (A+Cgtild)<Targ )+W .*( (A+Cgtild)>=Targ ) );
            Payoff = Cgain+Closs;
            Aplus  = A + Cgtild;
            if Na > 1
                Qnew(m,:) = (interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ))+Payoff;
            else
                Qnew(m) = Payoff;
            end
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
    price = interp1(S,Q(:,1),S0);
    option.set_error(NaN);
    plot(S,Q(:,1),'linewidth',1);
end
price = ApF*price;
option.CPU_time = cputime-cpu_t0;
end



