function [fYbis,A] = FixPointMixVector(fY,lambda,rows,cols)
%
%
%
% Compute for every position (frequency), the Barycenter texture using the FixPoint Equation
% fY: 3xNxT
% output: dimensions: (N,N,Colors) in the Fourier Domain!

[Colors,N,Textures] = size(fY);

if ((N ~= (rows*cols)) || (rows ~= cols))
    disp(['FixPointMix:Error in dimensions!']);
else 
    N = rows; %or cols, the image should be squared
end 

%Obtain the covariance matrices of each texture

fS = zeros( Colors, Colors, N*(N/2+1), Textures);
for t = 1:Textures
    %3x3x(N* (N/2+1) )xT 
    fS(:,:,:,t) = parallel_mult_vec_vec_3x3(fY(:,1:N*(N/2+1),t),conj(fY(:,1:N*(N/2+1),t)));
end

S = fS(:,:,:,1);
%compute the central S
S = parallel_compute_gaussian_mapping(S,fS,lambda);

[Va,Ve] = Eigens3x3(S);      

A = zeros(Colors,Colors,N*(N/2+1));
for i=1:3
    %multiplying eigen vector with eigen value to generate the new matrix
    A(:,i,:) = Ve(:,i,:) .* repmat(Va(i,1,:).^0.5,[3 1 1]);
end

W = randn(Colors,1,N*(N/2+1))+ 1i * randn(Colors,1,N*(N/2+1));

aa =  parallel_mult3x3(A,W);

fYbis = zeros(N,N,3);
%consequence of being hermitian
fYbis(:,1:(N/2+1),1) = reshape(aa(1,:,:), N,(N/2+1),1);   
fYbis(:,1:(N/2+1),2) = reshape(aa(2,:,:), N,(N/2+1),1);   
fYbis(:,1:(N/2+1),3) = reshape(aa(3,:,:), N,(N/2+1),1); 


%SS = zeros(size(S));
for i = 1:N
    for j = 1:N/2+1
     fYbis( mod( N-i+1,N)+1,mod( N-j+1,N )+1,:) = conj(fYbis(i,j,:));  
    end 
end 
   

function C = parallel_mult_vec_vec_3x3(A,B)
%A: 3xN, B: 3xN

N = size(A,2);
C = zeros(3,3,N);

 for i=1:size(A,1)     
        C(i,1,:) = A(i,:).*B(1,:);
        C(i,2,:) = A(i,:).*B(2,:);
        C(i,3,:) = A(i,:).*B(3,:);
end
