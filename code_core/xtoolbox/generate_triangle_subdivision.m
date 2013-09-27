function [X,lambda] = generate_triangle_subdivision(J)

X0 = [[0;0] [1;0] [1/2;sqrt(3)/2]];
lambda = [[1;0;0] [0;1;0] [0;0;1]];
X = X0;
F = [1;2;3];
for j=1:J
    n = size(X,2);
    m = size(F,2);
    for i=1:m
        f = F(:,i);
        k = size(X,2);
        %
        lambda(:,end+1) = mean(lambda(:,f(1:2)),2);
        lambda(:,end+1) = mean(lambda(:,f(2:3)),2);
        lambda(:,end+1) = mean(lambda(:,f([1 3])),2);
        %
        X(:,end+1) = mean(X(:,f(1:2)),2);
        X(:,end+1) = mean(X(:,f(2:3)),2);
        X(:,end+1) = mean(X(:,f([1 3])),2);
        %
        F(:,end+1) = k + [1;2;3];
        F(:,end+1) = [f(1);k+1;k+3];
        F(:,end+1) = [f(2);k+1;k+2];
        F(:,end+1) = [f(3);k+2;k+3];
    end
end