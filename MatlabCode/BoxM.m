function [A,B] = BoxM(a,b)
U = rand;
V = rand;
E = -2*log(U);
A = sqrt(E)*cos(2*pi*V);
B = sqrt(E)*sin(2*pi*V);
A = a + sqrt(b)*A;
B = a + sqrt(b)*B;