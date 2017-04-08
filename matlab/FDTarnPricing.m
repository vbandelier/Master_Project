function [ Price ] = FDTarnPricing(S0,K,r_d,r_f,sigma,period,Targ,N_fixDates,Nx,Nt,Na,KO_type,theta)
T = N_fixDates*period;

Smin = S0 * exp(min((r_d-r_f-0.5*sigma^2)*T-3*sigma*T,-3*sigma*T));
Smax = S0 * exp(max((r_d-r_f-0.5*sigma^2)*T+3*sigma*T,3*sigma*T));

% set grid and grid-size.
h = (Smax-Smin)/Nx;
dt = period/Nt;

S = Smin + (0:Nx)*h;
%t = 0 + (0:Nt)*dt;
A = linspace(0,Targ,Na);

alpha = sigma^2*S.^2*dt/(2*h^2);
beta = (r_d-r_f)*S*dt/(2*h);

ll = alpha-beta;
dd = -2*alpha-r_d*dt;
uu = alpha + beta;

dd(1) = -2*beta(1)-r_d*dt;
uu(1) = 2*beta(1);
dd(end) = -2*beta(end)-r_d*dt;
ll(end) = 2*beta(end);

Amat = spdiags([NaN; uu(1:end-1)'],1,Nx+1,Nx+1) +...
    spdiags(dd',0,Nx+1,Nx+1) +...
    spdiags([ll(2:end)'; NaN],-1,Nx+1,Nx+1);

B = speye(Nx+1,Nx+1)-theta*Amat;


%% Code
% step 1
U = zeros(Nx+1,Na);
% ------
Unew = U;
for k = 1:N_fixDates
    for m = 1:Nx+1
        Ctild = max(S(m)-K,0);
        switch KO_type
            case 'fullGain'
                W = 1;
            case 'noGain  '
                W = 0;
            case 'partGain'
                W = (Targ-A)/(S(m)-K);
        end
        C = Ctild .* ( ( (A+Ctild)<Targ )+W .*( (A+Ctild)>=Targ ) );
        % step 2
        Aplus  = A + Ctild;
        % step 3/4
        Unew(m,:) = (interp1(A,U(m,:),Aplus,'spline').*(Aplus<Targ))+C;
    end
    for j = 1:Na
        % init matrix containing the solution at each time step
        V = zeros(Nx+1,Nt+1);
        V(:,1) = Unew(:,j);
        for m = 2:Nt+1
            F = (speye(Nx+1,Nx+1)+(1-theta)*Amat)*V(:,m-1);
            V(:,m) = B\F;
        end
        U(:,j) = V(:,end);
    end
    %% Plot surface
%     surf(U);
%     getframe(gcf);
end
%%
Price = interp1(S,U(:,1),S0);
plot(S,U(:,1))