function Change_VG(sigma,nu,theta)
C = 1/nu;
G = (sqrt(0.25*theta*theta*nu*nu+0.5*sigma*sigma*nu)-0.5*theta*nu)^(-1);
M = (sqrt(0.25*theta*theta*nu*nu+0.5*sigma*sigma*nu)+0.5*theta*nu)^(-1);
fprintf('\t%+6.4f \t\n',C);
fprintf('\t%+6.4f \t\n',G);
fprintf('\t%+6.4f \t\n',M);