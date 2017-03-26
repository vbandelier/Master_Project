function [ Price ] = GHQCTarnPricing(S0,K,r_d,r_f,sigma,period,Targ,N_fixDates,Nx,Na,KO_type,q_order)
T = N_fixDates*period;
dt = period;

A = linspace(0,Targ,Na);

% Hermite polynomials of order q_order :
u = sqrt((1:q_order-1)/2);
[V,Lambda] = eig(diag(u,1)+diag(u,-1));
[xi,i] = sort(diag(Lambda));
Vtop = V(1,:);
Vtop = Vtop(i);
w = sqrt(pi)*Vtop.^2;

% step 1 :
tau = sigma*sqrt(dt);
nu =(r_d-r_f-0.5*sigma^2)*dt;
Smin = S0 * exp(min((r_d-r_f-0.5*sigma^2)*T-3*sigma*T,-3*sigma*T));
Smax = S0 * exp(max((r_d-r_f-0.5*sigma^2)*T+3*sigma*T,3*sigma*T));

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
        Aplus  = sort(A + C);
        Qnew(m,:) = (interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ))+C;
    end
    for j = 1:Na
        % Step 3 :
        Qint = griddedInterpolant(X,Qnew(:,j),'cubic');
        % step 4 :
        for m = 1:Nx+1
            Q(m,j) = exp(-r_d*dt)/sqrt(pi) * (w*Qint(sqrt(2)*tau*xi+nu+X(m)));
        end
    end
    %% Plot surface
    surf(Q);
    getframe(gcf);
end
%%
Price = interp1(S,Q(:,1),S0);
