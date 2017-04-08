function [ Price ] = CONVTarnPricing(S0,K,r_d,r_f,sigma,period,Targ,N_fixDates,Nx,Na,KO_type,alpha)
T = N_fixDates*period;
dt = period;

A = linspace(0,Targ,Na);

Smin = S0 * exp(min((r_d-r_f-0.5*sigma^2)*T-3*sigma*T,-3*sigma*T));
Smax = S0 * exp(max((r_d-r_f-0.5*sigma^2)*T+3*sigma*T,3*sigma*T));
Xmin = log(Smin);
Xmax = log(Smax);

dx = (Xmax-Xmin)/Nx;
x = Xmin + (0:Nx-1)*dx;
du = 2*pi/(Nx*dx);

mu = (r_d-r_f-0.5*sigma^2);
phi = @(u) exp(1i*u*mu*dt-0.5*sigma^2*u.^2*dt);


u = ((0:Nx-1)-Nx/2)*du;
y = x;

w = ones(1,Nx);
w(1) = 0.5; w(end) = 0.5;

S = S0*exp(x);
% step 2 :
Q = zeros(Nx,Na);
Qnew = Q;
for k = 1:N_fixDates
    for m = 1:Nx
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
        Aplus  = A + Ctild;
        Qnew(m,:) = (interp1(A,Q(m,:),Aplus,'spline').*(Aplus<Targ))+C;
    end
    for j = 1:Na
        % Step 1 :
        res1 = ifft((-1).^(0:Nx-1).*w.*exp(alpha*y).*Qnew(:,j)');

        % Step 2 :
        res2 = res1 .* phi(-(u-1i*alpha));

        % Step 3 :
        res3 = real(exp(-alpha.*x).*(-1).^(0:Nx-1).* fft(res2));
        
        Q(:,j)=res3;
    end
end
%%
Price = interp1(S,Q(:,1),S0);
plot(S,Q(:,1))
