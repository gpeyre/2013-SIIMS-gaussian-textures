function [h_in, h_out] = plot_ellipse(T,m,r, color_bound, color_inside)

% plot_ellipse - draw ellipse
%
%   hb = plot_ellipse(T,m,r, color_bound, color_inside);
%
%   T is the tensor of the ellipse
%   m is the center
%   r is the radius
%
%   Copyright (c) 2010 Gabriel Peyre

if nargin<4
    color_bound = 'b';
end
if nargin<5
    color_inside = 'r';
end
if nargin<3
    r = 1;
end


n = 48;
t = linspace(0,2*pi,n);
x = [cos(t); sin(t)];

[V,S] = eig(T);
S = max(real(S),0);
y = r * V*sqrt(S)*x + repmat(m, [1 n]);
y = real(y);

X = [y(1,:); [y(1,2:end) y(1,1)]; zeros(1,n) + m(1)];
Y = [y(2,:); [y(2,2:end) y(2,1)]; zeros(1,n) + m(2)];
Z = zeros(3,n);

hold on;
h_in = patch(X,Y,Z);
set(h_in,'FaceColor', (color_inside));
set(h_in,'EdgeColor', 'none');

h_out = plot(y(1,:),y(2,:), 'color', color_bound);
