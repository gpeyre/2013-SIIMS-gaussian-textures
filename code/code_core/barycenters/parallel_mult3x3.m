function C = parallel_mult3x3(A,B)
%Assuming size of vectors are (3,X,:)
% if X=1 we have a vector multiplication
% if X=3 we have a matrix multiplication


if ( (size(B,2) == 3) && (size(A,2) == 3) ) %two matrices
    C = parallel_mult_matrix_matrix_3x3(A,B);
else
    if (size(A,2) == 3) % one matrix (3x3xN) and one vector(3x1xN) 
        C = parallel_mult_matrix_vec_3x3(A,B);
    else 
        C = parallel_mult_vec_vec_3x3(A,B);% two vectors 3x1xN
    end 
end 


function C = parallel_mult_matrix_matrix_3x3(A,B)

C = zeros(3,3,size(A,3));

for i=1:size(A,1)
    for j=1:size(B,2)
        C(i,j,:) = A(i,1,:).*B(1,j,:) + ...
                   A(i,2,:).*B(2,j,:) + ...
                   A(i,3,:).*B(3,j,:);
    end    
end 

function w = parallel_mult_matrix_vec_3x3(A,v)

w = zeros(3,1,size(A,3));

for i=1:3
    w(i,1,:) = A(i,1,:).*v(1,1,:) + ...
               A(i,2,:).*v(2,1,:) + ...
               A(i,3,:).*v(3,1,:);    
end 

function C = parallel_mult_vec_vec_3x3(A,B)

C = zeros(3,3,size(A,3));

for i=1:size(A,1)
        C(i,1,:) = A(i,1,:).*B(1,1,:);
        C(i,2,:) = A(i,1,:).*B(2,1,:);
        C(i,3,:) = A(i,1,:).*B(3,1,:);
      
end 