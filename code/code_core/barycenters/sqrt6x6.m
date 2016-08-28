function sqrtA = sqrt6x6(A)
% sqrtA - the squared root of each A(:,:,i)
%
%       B = sqrt6x6(A)
%
% assumptions: A is hermitian, and with size 3x3xN

%Copyright (c) 2012 Sira Ferradans

N = size(A, 3);

sqrtA = zeros(6,6,N);

for i = 1: N
   sqrtA(:,:,i) = sqrtm(A(:,:,i)); 
end

% N = size(A,6);
% 
% %%compute eigens
% [Va,Ve] = Eigens3x3(A);
% Va = max(Va,0);
% Va = real(Va);
%  
% 
% %%apply pow 0.5 to each eigen value 
% Va = Va.^0.5;
% 
% %%build each matrix: Ve Va.^0.5 Ve'
% C = zeros(6,6,N);
% 
% for i=1:6
%     C(:,i,:) = Ve(:,i,:) .* repmat(Va(i,1,:),[6 1 1]) ;
% end
% 
% sqrtA = zeros(3,3,N);
% for i=1:3
%     sqrtA(:,i,:) = parallel_mult3x3(C, reshape(conj(Ve(i,:,:)),3,1,N) );
% end 
% 
% 
% 
% 
% 
