function A = FixPointMixVector_video(fY, lambda, rows, cols, nf)
% Compute for every position (frequency), the barycenter texture using the FixPoint Equation
% fY: 3xNxT
% output: dimensions: (rows, cols, nf, Colors) in the Fourier Domain!


[Colors, N, Textures] = size(fY);

% if ((N ~= (rows*cols)) || (rows ~= cols))
%     disp(['FixPointMix: Error in dimensions!']);
% % else 
% %     N = rows; % or cols, the image should be squared
% end 

%Obtain the covariance matrices of each texture

fS = zeros(Colors, Colors, N, Textures);

for t = 1:Textures
    %3x3xNxT 
    fS(:,:,:,t) = parallel_mult_vec_vec_3x3(fY(:,:,t),conj(fY(:,:,t)));
end

S = fS(:,:,:,1);
%compute the central S
S = parallel_compute_gaussian_mapping(S,fS,lambda);

[Va,Ve] = Eigens3x3(S);      

A = zeros(Colors,Colors,N);
for i=1:3
    % multiplying eigen vector with eigen value to generate the new matrix
    A(:,i,:) = Ve(:,i,:) .* repmat(Va(i,1,:).^0.5,[3 1 1]) ;
end

W = randn(Colors,1,N)+ 1i*randn(Colors,1,N);
A =  parallel_mult3x3(A,W);

% fYbis = zeros(N,N,3);
% %consequence of being hermitian
% fYbis(:,1:(N/2+1),1) = reshape(aa(1,:,:), N,(N/2+1),1);   
% fYbis(:,1:(N/2+1),2) = reshape(aa(2,:,:), N,(N/2+1),1);   
% fYbis(:,1:(N/2+1),3) = reshape(aa(3,:,:), N,(N/2+1),1); 


%    %SS = zeros(size(S));
% for i = 1:N
%     for j = 1:N/2+1
%      fYbis( mod( N-i+1,N)+1,mod( N-j+1,N )+1,:) = conj(fYbis(i,j,:));  
%     end 
% end 
   

function C = parallel_mult_vec_vec_3x3(A,B)
%A: 3xN, B: 3xN

N = size(A,2);
C = zeros(3,3,N);

 for i=1:size(A,1)
%         C(i,1,:) = reshape(A(i,:).*B(1,:),1,1,N);
%         C(i,2,:) = reshape(A(i,:).*B(2,:),1,1,N);
%         C(i,3,:) = reshape(A(i,:).*B(3,:),1,1,N);
%         
%         
        C(i,1,:) = A(i,:).*B(1,:);
        C(i,2,:) = A(i,:).*B(2,:);
        C(i,3,:) = A(i,:).*B(3,:);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [fYbis,A] = FixPointMixVector(fY,lambda,rows,cols)
% %Compute for every position (frequency), the Barycenter texture using the FixPoint Equation
% % fY: 3xNxT
% %output: dimensions: (N,N,Colors) in the Fourier Domain!
% 
% addpath(['./toolbox/']);
% 
% [Colors,N,Textures] = size(fY);
% 
% if ((N ~= (rows*cols)) || (rows ~= cols))
%     disp(['FixPointMix:Error in dimensions!']);
% else 
%     N = rows; %or cols, the image should be squared
% end 
% 
% %Obtain the covariance matrices of each texture
% 
% J=repmat(1:(N/2+1), [ N     1]);
% I=repmat([1:N]'   , [ 1 N/2+1]);
% index = (J-1)*N+I;
% 
% fS = zeros( Colors,Colors,N*(N/2+1),Textures );
% for t = 1:Textures
%     %3x3xTx(N* (N/2+1) ) 
%     fS(:,:,:,t) = parallel_mult_vec_vec_3x3(fY(:,index(:),t),conj(fY(:,index(:),t)));
% end
% 
% S = fS(:,:,:,1);
% %compute the central S
% S = parallel_compute_gaussian_mapping(S,fS,lambda);
% [Va,Ve]=Eigens3x3(S);      
% 
% A = zeros(Colors,Colors,N*(N/2+1));
% for i=1:3
%     A(:,i,:) = Ve(:,i,:) .* repmat(Va(i,1,:).^0.5,[3 1 1]) ;
% end
% 
% W = randn(Colors,1,N*(N/2+1))+ 1i * randn(Colors,1,N*(N/2+1));
% fYbis = zeros(N,N,3);
% fYbis(1:N,1:(N/2+1),:) = reshape( parallel_mult3x3(A,W), N,N/2+1,3);       
%       
% i=1:N;
% j=1:(N/2+1);
% fYbis(mod( N-i+1,N)+1,mod( N-j+1,N )+1,:) = conj(fYbis(i,j,:));
%  
% 
% function C = parallel_mult_vec_vec_3x3(A,B)
% %A: 3xN, B: 3xN
% 
% N = size(A,2);
% C = zeros(3,3,1,N);
% 
% for i=1:size(A,1)
%         C(i,1,1,:) = reshape(A(i,:).*B(1,:),1,1,1,N);
%         C(i,2,1,:) = reshape(A(i,:).*B(2,:),1,1,1,N);
%         C(i,3,1,:) = reshape(A(i,:).*B(3,:),1,1,1,N);
% end