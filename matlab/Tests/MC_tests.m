S0 = 100;
K = 90:5:120;
r = 0.0;
q = 0.0;
T = 1;

N = 1;
M = 1e5;

sigma = 0.12;
theta = -0.14;
nu = 0.2;

lambda = 1;
a = 0;
d = 1;
eta1 = 10;
eta2 = 5;
p = 0.6;

alpha = 28.42141;
beta = -15.08623;
delta = 0.31694;


% [Smer,t] = Merton_generator( S0,r,q,sigma,lambda,a,d,T,N,M );
% [Skou,~] = Kou_generator( S0,r,q,sigma,lambda,p,eta1,eta2,T,N,M );
Snig = NIG_generator( S0,r,q,T,N,alpha,beta,delta,M );
Svg  = VG_generator( S0,r,q,T,N,theta,sigma,nu,M );

Call_payoff = @(s,k) max(s-k,0);
Put_payoff = @(s,k) max(k-s,0);

% Cmer = exp(-r*T)*mean(Call_payoff(Smer(:,end),K))
% Pmer = exp(-r*T)*mean(Put_payoff(Smer(:,end),K))
% 
% Ckou = exp(-r*T)*mean(Call_payoff(Skou(:,end),K))
% Pkou = exp(-r*T)*mean(Put_payoff(Skou(:,end),K))
% 
i = 0;
for k = K
    i=i+1;
Cnig(i) = exp(-r*T)*mean(Call_payoff(Snig(end,:),k));
Pnig(i) = exp(-r*T)*mean(Put_payoff(Snig(end,:),k));
% 
Cvg(i)  = exp(-r*T)*mean(Call_payoff(Svg(end,:),k));
Pvg(i)  = exp(-r*T)*mean(Put_payoff(Svg(end,:),k));
end

%[Call, Put] = blsprice(S0,K,r,T,sigma,q)
