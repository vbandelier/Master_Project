vol = [ 7.3360	7.1670	7.0740	6.9710	6.9500	7.0210	7.2270	7.4610	7.8210	8.0750	8.4500
    7.3120	7.1310	7.0310	6.9240	6.9030	6.9950	7.2380	7.5120	7.9160	8.1970	8.6210
    7.5920	7.4160	7.3200	7.2190	7.1940	7.2770	7.5040	7.7650	8.1400	8.4050	8.8060
    8.0300	7.7980	7.6630	7.5170	7.4720	7.5440	7.7770	8.0520	8.4860	8.7920	9.2520
    7.7430	7.4720	7.3130	7.1390	7.0770	7.1520	7.4030	7.7120	8.1880	8.5250	9.0380
    7.9680	7.6250	7.4130	7.1780	7.1010	7.1790	7.4580	7.8060	8.3560	8.7450	9.3430
    8.1750	7.8120	7.5920	7.3450	7.2560	7.3340	7.6210	7.9780	8.5470	8.9520	9.5740
    8.3940	7.9870	7.7340	7.4580	7.3610	7.4360	7.7340	8.1110	8.7310	9.2000	9.8600
    8.5290	8.0940	7.8270	7.5260	7.4220	7.4990	7.8050	8.2010	8.8550	9.3240	10.0350
    8.9120	8.4110	8.1100	7.7690	7.6460	7.7260	8.0560	8.4970	9.2320	9.7710	10.5710
    9.2570	8.7020	8.3580	7.9740	7.8280	7.9080	8.2430	8.7070	9.4980	10.0840	10.9350]/100;
delta = [5 10 15 25 35 50 65 75 85 90 95];
T = [1/52,2/52,3/52,1/12,2/12,3/12,4/12,5/12,6/12,9/12,1];
r = [-0.01298 -0.01453 -0.01332 -0.01225 -0.01275 -0.01247 -0.01194 -0.01233 -0.01220 -0.01242 -0.01237];
q = [ 0.00707  0.00584  0.00712  0.00867  0.01002  0.01023  0.01065  0.01094  0.01116  0.01166  0.01197];

figure(1)
surf(delta, T', vol)
title('Implied vol surface')

S0 = 0.9730;

dminus = @(S0,K,r,q,T,sigma) (log(S0*exp((r-q)*T)/K)-0.5*sigma^2*T)/(sigma*sqrt(T));
dplus = @(S0,K,r,q,T,sigma) (log(S0*exp((r-q)*T)/K)+0.5*sigma^2*T)/(sigma*sqrt(T));

bsprice = @(S0,K,r,q,T,sigma,opt_type) opt_type*(S0*exp(-q*T)*normcdf(opt_type*dplus(S0,K,r,q,T,sigma))-...
    K *exp(-r*T)*normcdf(opt_type*dminus(S0,K,r,q,T,sigma)));
bsdelta = @(S0,K,r,q,T,sigma,opt_type) opt_type*exp(-q*T)*normcdf(opt_type*dplus(S0,K,r,q,T,sigma));

figure(2)
imp_vol = vol;
for k = 1:4
    switch k
        case 1
            model = Model('Mer',[0.0649    0.1303   -0.0584    0.1603]);
        case 2
            model = Model('Kou',[0.0665    0.1305    0.0751    3.3154    9.0490]);
        case 3
            model = Model('NIG',[18.8491   -3.9281    0.1250]);
        case 4
            model = Model('VG',[-0.0324    0.0810    0.2451]);
    end
    for i = 1:11
        for j = 1:11
            Opt_type = (delta(i)<=50)-(delta(i)>50);
            gain_fun = @(S,K) max(Opt_type*(S-K),0);
            
            K = S0*exp((r(j)-q(j))*T(j))*exp(-Opt_type*vol(j,i)*sqrt(T(j))*...
                norminv(exp(-q(j)*T(j))*min(delta(i),100-delta(i))/100,0,1)+...
                0.5*vol(j,i)^2*T(j));
            
            option = Option(S0,r(j),q(j),K,T(j),1,gain_fun,@(S,K) 0.*S,0,1000,'F',1);
            
            method = Method('Conv',[1, 1000, -Opt_type]);
            
            price = Pricer(option,model,method);
            
            imp_vol(j,i) = fminsearch(@(sigma) abs(bsprice(S0,K,r(j),q(j),T(j),sigma,Opt_type)-price),vol(j,i));
            
            delta_model(j,i) = bsdelta(S0,K,r(j),q(j),T(j),imp_vol(j,i),Opt_type);
        end
    end
    delta_model = 100*(delta_model+[0,0,0,0,0,0,1,1,1,1,1]);
    subplot(2,2,k)
    surf(delta_model, T', imp_vol)
    hold on
    title(model.name)
end