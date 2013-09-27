function [Va,Ve]=Eigens3x3(A)
% Eigens3x3 -- computes the eigenvalues and eigenvectors of each matrix 3x3 of A.
%
%           [Va,Ve] = Eigens3x3(A)
% 
% Size A: 3x3xN,  we assume A is Hermitian

%Copyright (c) 2012 Sira Ferradans

%A(:,:,1)=[a  b  c
%          b' e  d 
%          c' d' g]


N = size(A,3);

trA = A(1,1,:)+A(2,2,:)+A(3,3,:);% tr(A)=a+e+g

% tr(A^2) = a^2 + e.^2 + g.^2 + 2*(b*b'+d*d'+c*c')
%trA2=    A(1,1,:).*A(1,1,:) +  A(2,2,:).*A(2,2,:)+ A(3,3,:).*A(3,3,:) + ...
%      2*(A(1,2,:).*A(2,1,:) +  A(1,3,:).*A(3,1,:)+ A(3,2,:).*A(2,3,:));

 % det = aeg+bdc'+b'd'c-c*c'e-b*b'g-d*d'a
detA = A(1,1,:).*A(2,2,:).*A(3,3,:)+...
       A(1,3,:).*A(2,1,:).*A(3,2,:)+...
       A(3,1,:).*A(1,2,:).*A(2,3,:)-...
       A(1,3,:).*A(2,2,:).*A(3,1,:)-...
       A(1,1,:).*A(3,2,:).*A(2,3,:)-...
       A(3,3,:).*A(1,2,:).*A(2,1,:);
%detA = max(double(detA),0);

tres = -A(2,2,:).*A(3,3,:)-A(2,2,:).*A(1,1,:)-A(1,1,:).*A(3,3,:)+A(1,3,:).*A(3,1,:)+A(2,3,:).*A(3,2,:)+A(1,2,:).*A(2,1,:);
 
%The characteristic polynomial gives us the following coef:

%P = reshape([ -ones(1,1,N) trA 0.5*(trA2-trA.*trA) detA ],4,N);% -r^3 + tr(A)*r^2 + 1/2*(tr(A^2)-tr(A)^2)*r+det(A)
P = reshape([ -ones(1,1,N) trA tres detA ],4,N);
P(abs(double(P))<=eps) = 0;

Va = reshape(poly_root(P),3,1,N);
%Va = reshape(roots(double(P)),1,3,N);


%impose conditions associated to the Hermitian matrix
Va(double(Va) < eps) = 0; %eigs should be semi-positive 
Va = real(Va); %eig should be real

%%Eigen vector computation: should be orthogonal among each other

Ve = zeros(3,3,N);
%Equations defined from the characteristic polynom

for i=1:3
    AA = A(2,3,:).*(A(1,1,:)-Va(i,1,:)) - A(1,3,:).*A(2,1,:);
    BB = A(2,3,:).*A(1,2,:)-A(1,3,:).*(A(2,2,:)-Va(i,1,:));

    Ve(1,i,:) = - A(1,3,:).*BB;
    Ve(2,i,:) =   A(1,3,:).*AA;
    Ve(3,i,:) =  (A(1,1,:)-Va(i,1,:)).*BB - A(1,2,:).*AA;

    Ve(:,i,:) = Ve(:,i,:) ./ repmat(sqrt(sum(conj(Ve(:,i,:)).*Ve(:,i,:),1)),[3 1 1]);

end

%preparing to return
Ve(isnan(Ve)) = 0;

%Va = double(Va);
%Ve = double(Ve);



