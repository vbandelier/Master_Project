%% Gauss-Hermite Quadrature with Cubic interpolation (GHQC)
clear 
clc
%  European Option
S0 = 100;
K  = 100;
sigma = 0.2;
r = 0.07;
q = 0.03;
T = 1;

M = 300;
Nt = 1;
q_orders = (2:100);

% BLS price
[c,p] = blsprice(S0,K,r,T,sigma,q); 
price = zeros(length(Nt),length(q_orders));
%% Test for convergence in q_order
for iq = 1:length(q_orders)
    q_order = q_orders(iq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = sqrt((1:q_order-1)/2);
[V,Lambda] = eig(diag(u,1)+diag(u,-1));
[xi,i] = sort(diag(Lambda));
Vtop = V(1,:);
Vtop = Vtop(i);
w = sqrt(pi)*Vtop.^2;

%% Test for convergence in time
for it = 1:length(Nt)
     N = Nt(it)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1
Smin = S0 * exp(-5*sigma*sqrt(T));
Smax = S0 * exp(5*sigma*sqrt(T));

Xmin = log(Smin/S0);
Xmax = log(Smax/S0);

h = (Xmax-Xmin)/M;
X = Xmin + (0:M)*h;
S = S0*exp(X);
dt = T/N; 
t = (0:N)*dt;
 
tau = sigma*sqrt(dt);
nu =(r-q-0.5*sigma^2)*dt;
 
% Step 2
Q = max(K-S,0);

for k = 1:N
% Step 3
Qint = griddedInterpolant(X,Q,'linear');
 
% Step 4
Qnew = zeros(size(Q));
for m = 1:M+1
    Qnew(m) = exp(-r*dt)/sqrt(pi) * (w*Qint(sqrt(2)*tau*xi+nu+X(m)));
end

Q = Qnew;%max(Qnew,max(K-S,0));
end

price(it,iq) = interp1(S,Q,S0);
end
end

%% Plots
plot(q_orders,p*ones(size(q_orders)),'-k','linewidth',2)
hold on
plot(q_orders,price)
% for k = 1:length(q_orders)
%     plot(Nt,price(:,:))
% end
