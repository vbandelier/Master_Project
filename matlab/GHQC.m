%% Gauss-Hermite Quadrature with Cubic interpolation (GHQC)
clear 
clc
%  European Option
 S0 = 100;
 K  = 100;
 sigma = 0.2;
 r = 0;
 q = 0;
 T = 1;
 
 % BLS price
 [c,~] = blsprice(S0,K,r,T,sigma,q);
 
 