function S = compute_gaussian_mapping(S, Si,lambda)

[~,i] = max(lambda);
S = Si(:,:,i);
it = 1;
err = [];
NUMIT = 50;

for it =1:NUMIT
    S1 = gaussian_mapping(S,Si,lambda);
    err(it) = norm(S1-S);
    S=S1;

    if (err(it) < 1e-1)

    else 
        it = it+1;
    end 
end 

function S1 = gaussian_mapping(S,Si,lambda)

% gaussian_mapping - fixed point mapping for the barycenter of Gaussian distributions
%
%   S1 = gaussian_mapping(S,Si,lambda);
%
% The barycenter satisfies S1=S.
%
%   Copyright (c) 2011 Gabriel Peyre

S = S^(1/2);
S1 = S*0;
for i=1:length(lambda)
   S1 = S1 + lambda(i) * ( S*Si(:,:,i)*S )^(1/2); 
end