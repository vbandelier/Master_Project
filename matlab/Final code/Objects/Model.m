classdef Model
    %MODEL Model definition
    % Black-Scholes, Merton, Kou, NIG, VG
    
    properties
        name    % Name of the model
        param   % Vector of parameters
    end
    
    methods
        function model = Model(name,param)
            if name(1) == 'B'
                model.name = 'Black-Scholes';
            elseif name(1) == 'M'
                model.name = 'Merton';
            elseif name(1) == 'K'
                model.name = 'Kou';
            elseif name(1) == 'N'
                model.name = 'Normal Inverse Gaussian';
            elseif name(1) == 'V'
                model.name = 'Variance Gamma';
            else
                model.name = NaN;
            end
            model.param = param;
        end
        function S = generator(model, option, M)
            S0 = option.S0; r = option.r; q = option.q;
            N = option.N_fixDates; T = option.Period*N;
            if model.name(1) == 'B'
                sigma = model.param(1);
                S = BS_generator(S0,r,q,T,N,sigma,M);
            elseif model.name(1) == 'M'
                sigma = model.param(1);
                lambda = model.param(2);
                alpha = model.param(3);
                delta = model.param(4);
                S = Merton_generator(S0,r,q,T,N,sigma,lambda,alpha,delta,M);
            elseif model.name(1) == 'K'
                sigma = model.param(1);
                lambda = model.param(2);
                p = model.param(3);
                eta1 = model.param(4);
                eta2 = model.param(5);
                S = Kou_generator(S0,r,q,T,N,sigma,lambda,p,eta1,eta2,M);
            elseif model.name(1) == 'N'
                alpha = model.param(1);
                beta = model.param(2);
                delta = model.param(3);
                S = NIG_generator(S0,r,q,T,N,alpha,beta,delta,M);
            elseif model.name(1) == 'V'
                theta = model.param(1);
                sigma = model.param(2);
                nu = model.param(3);
                S = VG_generator(S0,r,q,T,N,theta,sigma,nu,M);
            end
        end
        function CF = char_fun(model, option)
            r = option.r; q = option.q;
            dt = option.Period;
            if model.name(1) == 'B'
                sigma = model.param(1);
                mu = r-q-0.5*sigma^2;
                CE = @(u) -0.5*sigma^2*u.^2;
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            elseif model.name(1) == 'M'
                sigma = model.param(1);
                lambda = model.param(2);
                alpha = model.param(3);
                delta = model.param(4);
                mu = r-q-0.5*sigma^2-lambda*(exp(alpha+0.5*delta^2)-1);
                CE = @(u) -0.5*sigma^2*u.^2+lambda*(exp(1i*alpha*u-0.5*delta^2*u.^2)-1);
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            elseif model.name(1) == 'K'
                sigma = model.param(1);
                lambda = model.param(2);
                p = model.param(3);
                eta1 = model.param(4);
                eta2 = model.param(5);
                mu = r-q-0.5*sigma^2-lambda*((p*eta1)/(eta1-1)+((1-p)*eta2)/(eta2+1)-1);
                CE = @(u) -0.5*sigma^2*u.^2+lambda*((p*eta1)./(eta1-1i*u)+((1-p)*eta2)./(eta2+1i*u)-1);
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            elseif model.name(1) == 'N'
                alpha = model.param(1);
                beta = model.param(2);
                delta = model.param(3);
                mu = r-q-delta*(sqrt(alpha^2-beta^2)-sqrt(alpha^2-(beta+1)^2));
                CE = @(u) delta*(sqrt(alpha^2-beta^2)-sqrt(alpha^2-(beta+1i*u).^2));
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            elseif model.name(1) == 'V'
                theta = model.param(1);
                sigma = model.param(2);
                nu = model.param(3);
                mu = r-q+log(1-theta*nu-0.5*sigma^2*nu)/nu;
                CE = @(u) -log(1-theta*nu*1i*u+0.5*sigma^2*nu*u.^2)/nu;
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            end
        end
        
        function levyf = levyf(model,x)
            if iscolumn(x)
                x=x';
            end
            
            xneg=x(x<0);
            xzero=x(x==0);
            xpos=x(x>0);
            
            if model.name(1) == 'B'
                levyf = 0.*x;
            elseif model.name(1) == 'M'
                lambda = model.param(2);
                alpha  = model.param(3);
                delta  = model.param(4);
                
                levyf = lambda/(sqrt(2*pi)*delta)*exp(-(x-alpha).^2/(2*delta^2));
            elseif model.name(1) == 'K'
                lambda = model.param(2);
                p      = model.param(3);
                eta1   = model.param(4);
                eta2   = model.param(5);
                
                levyf = [lambda * (1-p) * eta2 * exp(eta2*xneg),...
                             lambda * p * eta1 .* ones(1,length(xzero)),...
                             lambda * p * eta1 * exp(-eta1*xpos)];
            elseif model.name(1) == 'N'
                alpha = model.param(1);
                beta  = model.param(2);
                delta = model.param(3);
                
                levyf = [delta*alpha/pi*exp(beta*xneg).*besselk(1,alpha*abs(xneg))./abs(xneg),...
                         Inf(1,length(xzero)),...
                         delta*alpha/pi*exp(beta*xpos).*besselk(1,alpha*abs(xpos))./abs(xpos)];
            elseif model.name(1) == 'V'
                theta = model.param(1);
                sigma = model.param(2);
                nu = model.param(3);
                
                C = 1/nu;
                G = (sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)-0.5*theta*nu)^(-1);
                M = (sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)+0.5*theta*nu)^(-1);
                
                levyf = [C*exp(G*xneg)./abs(xneg), Inf(1,length(xzero)), C*exp(-M*xpos)./xpos];
            end
        end
        function levyf_epsi = levyf_epsi(model,x,epsi)
            
            if iscolumn(x)
                x=x';
            end
            
            xleft=x(x<-epsi);
            %xcenter=x( logical( (x>-epsi) .* (x<epsi) ) );
            xcenter=x( ~(x<-epsi) & ~(x>epsi) );
            xright=x(x>epsi);
            
            v1=model.levyf(epsi);
            v2=model.levyf(-epsi);
            m = ( v1-v2 ) / (2*epsi);
            
            levyf_epsi = [model.levyf(xleft), v1+m*(xcenter-epsi), model.levyf(xright)];
%             levyf_epsi = [model.levyf(xleft), zeros(size(xcenter)), model.levyf(xright)];
            
        end
        
        function sigma2 = get_sigma2_FD(model,epsi)
            if model.name(1) == 'B' || model.name(1) == 'M' || model.name(1) == 'K'
                sigma = model.param(1);
%             elseif model.name(1) == 'N'
%                 sigma = model.param(3);
%             elseif model.name(1) == 'V'
%                 sigma = model.param(2);
%             end  
            elseif model.name(1) == 'N' || model.name(1) =='V'
                sigma = sqrt(integral(@(y) y.^2.*(model.levyf(y)-model.levyf_epsi(y,epsi)), -epsi, 0 ) ...
                      + integral(@(y) y.^2.*(model.levyf(y)-model.levyf_epsi(y,epsi)), 0, epsi) );
%                 sigma = sqrt(integral(@(y) y.^2.*model.levyf(y), -epsi, 0 ) ...
%                     + integral(@(y) y.^2.*model.levyf(y), 0, epsi) );
%             else
%                 sigma_epsi = 0;
            end
            sigma2 = sigma^2 ;%+ sigma_epsi^2;
        end
        
        function lambda = get_lambda_FD(model,epsi,q_inf)
            if model.name(1) == 'B'
                lambda = 0;
            elseif model.name(1) == 'M' || model.name(1) == 'K'
                lambda = model.param(2);
            elseif model.name(1) == 'N' || model.name(1) == 'V' || model.name(1) == 'K'
                lambda = integral(@(y) model.levyf_epsi(y,epsi), -q_inf, q_inf);
            end
        end
        
        function c = get_c_FD(model,epsi,q_inf)
            if model.name(1) == 'B'
                c = 0;
            elseif model.name(1) == 'M' 
                lambda = model.param(2);
                alpha = model.param(3);
                delta = model.param(4);
                c = lambda*(exp(alpha+0.5*delta^2)-1);
            elseif model.name(1) == 'K'
                lambda = model.param(2);
                p      = model.param(3);
                eta1   = model.param(4);
                eta2   = model.param(5);
                c = lambda*(p*eta1/(eta1-1)+(1-p)*eta2/(eta2+1)-1);
            elseif model.name(1) == 'N' || model.name(1) == 'V'
                c = integral(@(y) (exp(y)-1).*model.levyf_epsi(y,epsi), -q_inf, q_inf);
            end
        end
    end
end

