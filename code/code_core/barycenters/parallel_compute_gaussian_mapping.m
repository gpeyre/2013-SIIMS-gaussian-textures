function S = parallel_compute_gaussian_mapping(S,Si,lambda)
% parallel_compute_gaussian_mapping - fixed point mapping for the
% barycenter of Gaussian distributions. Assuming 
%
%   S1 = parallel_compute_gaussian_mapping(S,Si,lambda);
%
% The barycenter satisfies S1=S.
%
% Parameters dimension: 
%
%
%   S     : 3x3xN
%   Si    : 3x3xNxT
%   lambda: 1xT
%
%
%   Copyright (c) 2012 Sira Ferradans

[~,i] = max(lambda);
S = Si(:,:,:,i);

[~,~,N,T] = size(Si);

NUMIT = 50;

for it =1:NUMIT
    
    sqrtS = sqrt3x3(S);
    
    S1 = zeros(size(S));
    
    for i =1:T
        % S^0.5 Si S^0.5
        C = parallel_mult3x3( sqrtS,parallel_mult3x3(Si(:,:,:,i), sqrtS));
 
        S1 = S1 + repmat(lambda(i),[3 3 N]) .*  sqrt3x3( C ); 
    
    end
    
    S=S1; 
    % norm(Si(:,:,:,1) - S1);
end 
%figure;%plot(log10(err));
%disp(['Order of err:' num2str(err(end))])

