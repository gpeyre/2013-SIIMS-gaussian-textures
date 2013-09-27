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


