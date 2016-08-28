% graphics in trilinear coordinates
%
% gsxia.lhi@gmail.com

clear all; 
close all;
clc;

%%
rep = '../results/barycenter/';

if not(exist(rep))
    mkdir(rep);
end

%%
n = 300;

vA = [1, 0];
vB = [1/2, sqrt(3)/2];

[Px, Py] = meshgrid(0:n, 0:n);
Px = Px./n;
Py = Py./n;

% triangle for dislapying
xlabel = sqrt(3)*Px - Py >=0 ;
ylabel = sqrt(3)*Px + Py - sqrt(3) <=0 ;
trilabel = xlabel & ylabel;

% from 2D Cartesian coordinates to trilinear coordinates
x = (Px.*vB(2) - Py.*vB(1))./( vA(1).*vB(2) - vA(2).*vB(1));
y = (Px.*vA(2) - Py.*vA(1))./(-vA(1).*vB(2) + vA(2).*vB(1));
z = 1 - x - y;

% display trilinear coordinates using color (x, y, z)
im = ones(n+1, n+1, 3);
im(:,:,1) = z.*trilabel + ~trilabel;
im(:,:,2) = x.*trilabel + ~trilabel;
im(:,:,3) = y.*trilabel + ~trilabel;
h1 = figure; 
imagesc(im); axis xy; axis equal; axis off;  hold on

%% 
% geodesics

s = 0:0.2:1;

% %% path2
ti = [1-s];
tj = [s/2];

xPx = ti.*vA(1) + tj.*vB(1);
yPy = ti.*vA(2) + tj.*vB(2);
iP = floor(xPx*n + 1);
jP = floor(yPy*n + 1);

plot(iP, jP, 'r-', 'LineWidth',2); hold on
for i = 1:length(iP)
    indi = iP(i); 
    indj = jP(i);
    plot(iP(i), jP(i), 'o', ... 
        'MarkerSize',10, ...
        'LineWidth',2,...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor',[z(indj,indi) x(indj,indi) y(indj,indi)] ); hold on
end

% %% path2
ti = s/2;
tj = s/2;

xPx = ti.*vA(1) + tj.*vB(1);
yPy = ti.*vA(2) + tj.*vB(2);
iP = floor(xPx*n + 1);
jP = floor(yPy*n + 1);

plot(iP, jP, 'r-', 'LineWidth',2); hold on
for i = 1:length(iP)
    indi = iP(i); 
    indj = jP(i);
    plot(iP(i), jP(i), 'o', ... 
        'MarkerSize',10, ...
        'LineWidth',2,...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor',[z(indj,indi) x(indj,indi) y(indj,indi)] ); hold on
end
%%
str = [rep 'trilinear-coordinates']; axis tight;
saveas(h1, [str '.eps'], 'epsc');
saveas(h1, [str '.png'], 'png');