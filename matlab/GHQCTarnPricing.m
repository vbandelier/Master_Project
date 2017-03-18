function [ Price ] = GHQCTarnPricing(S0,K,r_d,r_f,sigma,period,Targ,N_fixDates,Nx,Na,KO_type)
T = N_fixDates*period;
dt = period;

tau = sigma*sqrt(dt);
nu =(r_d-r_f-0.5*sigma^2)*dt;

A = linspace(0,Targ,Na);
% step 1 :
Smin = S0 * exp(min(nu*T-3*sigma*T,-3*sigma*T));
Smax = S0 * exp(max(nu*T+3*sigma*T,3*sigma*T));

Xmin = log(Smin/S0);
Xmax = log(Smax/S0);

h = (Xmax-Xmin)/Nx;
X = Xmin + (0:Nx)*h;
S = S0*exp(X);

% step 2 :
Q = zeros(Nx+1,Na);
Qnew = Q;
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
        Aplus  = A + C;
        Q(m,:) = interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ);
        Qnew(m,:) = Q(m,:)+C;
    end
    for j = 1:Na
        % Step 3 :
        Qint = griddedInterpolant(X,Qnew(:,j));
        % step 4 :
        %% q = 6 :
        xi = [-2.35061,  -1.33585,  -0.436077,  0.436077,   1.33585,    2.35061];
        w  = [0.00453001, 0.157067,  0.72463,   0.72463,    0.157067,   0.00453001];
        for m = 1:Nx+1
            Q(m,j) = exp(-r_d*dt)/sqrt(pi) * (w*Qint(sqrt(2)*tau*xi+nu+X(m))');
        end
    end
end
%%
Price = interp1(S,Q(:,1),S0);
