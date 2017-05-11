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
            S0 = option.S0; r = option.r; q = option.q; T = option.T;
            N = option.N_fixDates;
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
            dt = option.T/option.N_fixDates;
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
                mu = r-q-0.5*sigma-lambda*(exp(alpha+0.5*delta^2)-1);
                CE = @(u) -0.5*sigma+lambda*(exp(1i*alpha*u+0.5*delta^2*u.^2)-1);
                CF = @(u) exp(dt*(1i*u*mu+CE(u)));
            elseif model.name(1) == 'K'
                sigma = model.param(1);
                lambda = model.param(2);
                p = model.param(3);
                eta1 = model.param(4);
                eta2 = model.param(5);
                mu = r-q-0.5*sigma-lambda*((p*eta1)/(eta1+1)+((1-p)*eta2)/(eta2+1)-1);
                CE = @(u) -0.5*sigma+lambda*((p*eta1)./(eta1+1i*u)+((1-p)*eta2)./(eta2+1i*u)-1);
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
    end
end

