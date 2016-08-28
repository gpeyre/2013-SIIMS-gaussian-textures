%% 
% Codes for reproducing Figure 7.1 in the paper 
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%   by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% Copyright (c) 2012 Gabriel Peyre
%

clear all;
clc;
close all; 

addpath('./toolbox/');
addpath('./gaussian_2d/');

rep = '../results/barycenter/gaussian-interp/';

if not(exist(rep))
    mkdir(rep);
end

addpath('../xToolbox/');
addpath('gaussian_2d/');

%%
% Generate uniform points inside a triangles.

[X,lambda] = generate_triangle_subdivision(3);
X0 = X(:,1:3);

%%
% Generate the matrices

test = 'fixed'; 
%test = 'random-cpx';
%test = 'random-real';

%% change "aniso" to reproduce Figure (a)-(c) and (d)-(f) 
% aniso = .01*[1 1 1];
aniso = .01*[1 1 1];

%%
theta = [0. pi/3 2*pi/3];
Rot = @(theta)[cos(theta) sin(theta); -sin(theta) cos(theta)];
tensor = @(theta,a,b)Rot(theta)*diag([a,b])*Rot(-theta);

S = [];
for i=1:length(aniso)
    switch test
        case 'random-real'
            [U,R] = qr(randn(2));
            mu = [1; aniso(i)].^2;
            S(:,:,i) = U*diag(mu)*U';
        case 'random-cpx'
            U = randn(2) + 1i*randn(2); 
            [U,R] = eig(U + U');
            mu = [1; aniso(i)].^2;
            S(:,:,i) = U*diag(mu)*U';
        case 'fixed'
            S(:,:,i) = tensor(theta(i), 1, aniso(i)^2);
    end    
end

%% 
% Plot interpolation.

options.method = 'rao';

options.niter = 100;
r = .1;
figure; clf;
hold on;
for i=1:size(lambda,2);
    [S1,err,energy] = compute_gaussian_barycenter(S,lambda(:,i),options);    
    % display
    m1 = sum( X0.*repmat(lambda(:,i)', [2 1]), 2 );
    [h_in,h_out]  = plot_ellipse(S1, m1, r, [0 0 0], lambda(:,i)); hold on;
    set(h_out, 'LineWidth', 1);
end
axis tight; axis equal;
axis off;
str = [rep 'gaussian-interp-' options.method '-' num2str(aniso(1), '%2.0e')];
saveas(gcf, [str '.eps'], 'epsc');
saveas(gcf, [str '.png'], 'png');

%%
options.method = 'eucl';

options.niter = 100;
r = .1;
figure; clf;
hold on;
for i=1:size(lambda,2);
    [S1,err,energy] = compute_gaussian_barycenter(S,lambda(:,i),options);    
    % display
    m1 = sum( X0.*repmat(lambda(:,i)', [2 1]), 2 );
    [h_in,h_out]  = plot_ellipse(S1, m1, r, [0 0 0], lambda(:,i)); hold on;
    set(h_out, 'LineWidth', 1);
end
axis tight; axis equal;
axis off;
str = [rep 'gaussian-interp-' options.method '-' num2str(aniso(1), '%2.0e')];
saveas(gcf, [str '.eps'], 'epsc');
saveas(gcf, [str '.png'], 'png');

%%
options.method = 'ot';

options.niter = 100;
r = .1;
figure; clf;
hold on;
for i=1:size(lambda,2);
    [S1,err,energy] = compute_gaussian_barycenter(S,lambda(:,i),options);    
    % display
    m1 = sum( X0.*repmat(lambda(:,i)', [2 1]), 2 );
    [h_in,h_out]  = plot_ellipse(S1, m1, r, [0 0 0], lambda(:,i)); hold on;
    set(h_out, 'LineWidth', 1);
end
axis tight; axis equal;
axis off;
str = [rep 'gaussian-interp-' options.method '-' num2str(aniso(1), '%2.0e')];
saveas(gcf, [str '.eps'], 'epsc');
saveas(gcf, [str '.png'], 'png');