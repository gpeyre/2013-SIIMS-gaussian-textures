% demo for comparing Rao, Euclidean, OT geodesic for 1D Gaussion
% 
% For reproducing Figure 6.1 in the paper
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%   by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% Copyright (c) 2012 Gui-Song Xia
%

clear all; 
clc;
close all;

%%
save_rep = '../results/geodesic/Rao_OT_compare/';

if not(exist(save_rep))
    mkdir(save_rep);
end

%%
x = -5: 0.1: 15;
mu = [0 9];
sigma = [.5 1.5];

f0 = normpdf(x, mu(1), sigma(1));
f1 = normpdf(x, mu(2), sigma(2));

rho = sigma(1).^2 + ( (mu(1)- mu(2)).^2 - 2*(sigma(1).^2 - sigma(2).^2) ).^2 ./(8*(mu(1)- mu(2)).^2);
rho = rho.^0.5;

m = (mu(1) + mu(2))/2 + (sigma(1).^2 - sigma(2).^2)./(mu(1)- mu(2))/2;
rho = sigma(1).^2 + (m - mu(1)).^2;
rho = sigma(1).^2 + (m - mu(1)).^2;
rho = rho.^0.5;

phi = asin( sigma./ rho);
phi(mu<m) = pi - phi(mu<m);

%%
t = 0:0.2:1;
phi_t = (t)*phi(2) + (1-t)*phi(1);

mu_t_Rao    = m + rho.*cos(phi_t);
sigma_t_Rao = 0 + rho.*sin(phi_t);

%%
mu_t_OT    = (1-t)*mu(1) + t*mu(2);
sigma_t_OT = (1-t)*sigma(1) + t*sigma(2);

ft_Rao = zeros(length(t), length(x));
ft_OT = zeros(length(t), length(x));

for i = 1: length(t)
    ft_Rao(i, :) = normpdf(x, mu_t_Rao(i), sigma_t_Rao(i));
    ft_OT(i, :) = normpdf(x, mu_t_OT(i), sigma_t_OT(i));
end

%%
ColorD = (1-t)'*[1 0 0] + (t)'*[0 0 1];

h0 = figure;
plot(x, f0, 'r'); hold on
plot(x, f1, 'b'); hold on
legend('1st Gaussian', '2nd Gaussian');
for i = 1: length(t)
    plot(x, f0.*(1-t(i)) + f1.*t(i) , 'color', ColorD(i,:)); hold on;
end


h1 = figure;
plot(x, f0, 'r'); hold on
plot(x, f1, 'b'); hold on
legend('1st Gaussian', '2nd Gaussian');
for i = 1: length(t)
    plot(x, ft_Rao(i,:), 'color', ColorD(i,:)); hold on;
end

h2 = figure;
plot(x, f0, 'r'); hold on
plot(x, f1, 'b'); hold on
legend('1st Gaussian', '2nd Gaussian');
for i = 1: length(t)
    plot(x, ft_OT(i,:), 'color', ColorD(i,:)); hold on;
end


h3 = figure; 
plot(mu_t_Rao, sigma_t_Rao, 'r-'); hold on;
plot(mu_t_OT, sigma_t_OT, 'g-'); hold on;
legend('Rao-geodesic', 'OT-geodesic');
for i = 1: length(t)
    plot(mu_t_Rao(i), sigma_t_Rao(i), 's-', 'color', ColorD(i,:)); hold on;
    plot(mu_t_OT(i), sigma_t_OT(i), 'o-', 'color', ColorD(i,:)); hold on;
end

plot(mu(1), sigma(1), 'r+'); hold on;
plot(mu(2), sigma(2), 'bo'); hold on;
plot(m, 0, 'ro'); hold on;
axis equal;
xlabel('\mu');
ylabel('\sigma');

str = [save_rep '1d-gaussian-interp-' 'Euclidean' '-'];
saveas(h0, [str '.eps'], 'epsc');
saveas(h0, [str '.pdf'], 'pdf');

str = [save_rep '1d-gaussian-interp-' 'Rao' '-'];
saveas(h1, [str '.eps'], 'epsc');
saveas(h1, [str '.png'], 'png');

str = [save_rep '1d-gaussian-interp-' 'OT' '-'];
saveas(h2, [str '.eps'], 'epsc');
saveas(h2, [str '.png'], 'png');

str = [save_rep '1d-gaussian-geodesic-' 'Rao-OT' '-'];
saveas(h3, [str '.eps'], 'epsc');
saveas(h3, [str '.png'], 'png');
