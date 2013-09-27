function C = parallel_mult6x6(A,B)
%Assuming size of vectors are (3,X,:)
% if X=1 we have a vector multiplication
% if X=6 we have a matrix multiplication


if ( (size(B,2) == 6) && (size(A,2) == 6) ) %two matrices
    C = parallel_mult_matrix_matrix_6x6(A,B);
else
    if (size(A,2) == 6) % one matrix (3x3xN) and one vector(3x1xN) 
        C = parallel_mult_matrix_vec_6x6(A,B);
    else 
        C = parallel_mult_vec_vec_6x6(A,B);% two vectors 3x1xN
    end 
end 


function C = parallel_mult_matrix_matrix_6x6(A,B)

C = zeros(6,6,size(A,3));

for i=1:size(A,1)
    for j=1:size(B,2)
        C(i,j,:) = A(i,1,:).*B(1,j,:) + ...
                   A(i,2,:).*B(2,j,:) + ...
                   A(i,3,:).*B(3,j,:) + ...
                   A(i,4,:).*B(4,j,:) + ...
                   A(i,5,:).*B(5,j,:) + ...
                   A(i,6,:).*B(6,j,:);
    end    
end 

function w = parallel_mult_matrix_vec_6x6(A,v)

w = zeros(6,1,size(A,3));

for i=1:6
    w(i,1,:) = A(i,1,:).*v(1,1,:) + ...
               A(i,2,:).*v(2,1,:) + ...
               A(i,3,:).*v(3,1,:) + ...
               A(i,4,:).*v(4,1,:) + ...
               A(i,5,:).*v(5,1,:) + ...
               A(i,6,:).*v(6,1,:);    
end 

function C = parallel_mult_vec_vec_6x6(A,B)

C = zeros(6,6,size(A,3));

for i=1:size(A,1)
        C(i,1,:) = A(i,1,:).*B(1,1,:);
        C(i,2,:) = A(i,1,:).*B(2,1,:);
        C(i,3,:) = A(i,1,:).*B(3,1,:);
        C(i,4,:) = A(i,1,:).*B(4,1,:);
        C(i,5,:) = A(i,1,:).*B(5,1,:);
        C(i,6,:) = A(i,1,:).*B(6,1,:);      
end 