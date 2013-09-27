function [S,energy,err] = compute_gaussian_barycenter(Si,lambda,options)

% compute_gaussian_barycenter - compute the barycenter of covariances according to optimal transport
%
%   [S1,energy,err] = compute_gaussian_barycenter(Si,lambda,options);
%
%   Minimizes
%       E(S) = sum_i d(S,S(:,:,i))^2
%   where
%       d(A,B)^2 = tr( A + B - 2*(A*B)^(1/2)  )
%   
%   Copyright (c) 2011 Gabriel Peyre

niter = getoptions(options, 'niter', 1000);
force_real = getoptions(options, 'force_real', 0);
force_sym = getoptions(options, 'force_sym', 0);
method = getoptions(options, 'method', 'ot');

err = [];
energy = [];

% initialize with linear mean
u = reshape(lambda, [1 1 length(lambda)]);
S = sum( Si.*repmat(u, [size(Si,1) size(Si,1) 1]), 3);
        
switch method
    case 'eucl'
        %%% linear mean %%%
        % nothing
    case 'ot'
        %%% Optimal Transport with fix point iterations %%%
        for i=1:niter
            S1 = gaussian_mapping(S,Si,lambda);
            if force_real
                S1 = real(S1);
            end
            if force_sym
                S1 = (S1+S1')/2;
            end
            err(end+1) = norm(S-S1,'fro');
            energy(end+1) = barycenter_dist(S,Si,lambda);
            S = S1;
        end
        
    case 'rao'
        %%% Rao using gradient descent %%%
        
        Grad = @(S)compute_rao_barycenter_gradient(S,Si,lambda);        
        
        if 0
            options.bfgs_memory = 10;
            [S, energy, info] = perform_bfgs(Grad, S(:), options);
        else            
            eta = .1;
            energy = [];
            S = mean(Si,3);
            for i=1:niter
                [energy(end+1),G] = Grad(S);
                S = S - eta * G;
                if force_real
                    S = real(S);
                end
                if force_sym
                    S = (S+S')/2;
                end
            end
        end
        if energy(end)>energy(1)
            warning('Convergence problem');
        end
        
    otherwise        
        error('Unknown method');
        
end




function [S1,dist] = gaussian_mapping(S,Si,lambda)

% gaussian_mapping - fixed point mapping for the barycenter of Gaussian distributions
%
%   S1 = gaussian_mapping(S,Si,lambda);
%
% The barycenter satisfies S1=S.
%
%   Copyright (c) 2011 Gabriel Peyre

% transport_dist = @(S1,S2)abs( trace(S1 + S2 - 2*(S1^(1/2)*S2*S1^(1/2))^(1/2) ) );

S = S^(1/2);
S1 = S*0;
for i=1:length(lambda)
    S1 = S1 + lambda(i) * ( S*Si(:,:,i)*S )^(1/2); 
end

function [d,G] = compute_rao_barycenter_gradient(S,Si,lambda)

% compute_rao_barycenter_gradient - compute bayrcenter energy
%
%   [d,G] = compute_rao_barycenter_gradient(S,Si,lambda);
%
%   Compute the gradient G of the energy
%       d(S) = sum_i rho_i * norm( log(S^(-1/2)*Si(:,:,i)*S^(-1/2)) )^2
%
%   Copyright (c) 2011 Gabriel Peyre

m = length(lambda);

n = size(Si,1);
flat_mode = 0;
if size(S,1)==n*n
    flat_mode = 1;
    S = reshape(S,n,n);
end

Z = S^(1/2);
Zi = Z^(-1);

d = 0;
G = S*0;
for i=1:m
    Li = logm(Zi*Si(:,:,i)*Zi);
    d = d + lambda(i) * norm(Li, 'fro')^2;
    G = G + lambda(i) * Li;
end
G =  - Z * G * Z;

if flat_mode==1
    G = G(:);
end


