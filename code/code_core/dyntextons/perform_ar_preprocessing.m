function [f0 f_MEAN] = perform_ar_preprocessing(f0)
%
% This function removes the mean of the texture and
% compute the periodic component of the texture
%
% guisong.xia@whu.edu.cn
% 
[m0, n0, ~, tau0] = size(f0);
f_MEAN = squeeze(mean(mean(mean(f0, 4),1),2));
f0 = f0 - permute(repmat(f_MEAN, [1, m0, n0, tau0]), [2 3 1 4]);
% f = PeriodicComp_3d(X);
f0 = PeriodicComp(f0);

function p = PeriodicComp(h)
%
%
% compute the periodic component of h
% 
[m, n, dm] = size(h);

p = zeros(size(h));
for d = 1:dm
    Hhat = intLaplace(h(:,:,d));
    FHhat = fft2(Hhat);

    [X Y] = meshgrid(0:n-1, 0:m-1);
    FPhat = FHhat./(4 -2.*cos(2.*X*pi/n) -2.*cos(2.*Y*pi/m));
    FPhat(1,1) = sum(sum(h(:,:,d)));

    p(:,:,d) = real(ifft2(FPhat));
end

function p = intLaplace(h)
% Compute the discrete Laplacian in the interior of the image domain
Hext = [0, h(1,:), 0; h(:,1), h, h(:,end); 0, h(end,:), 0;];

p = 4.*Hext - ( circshift(Hext,[0 1]) + circshift(Hext,[1 0]) +...
                circshift(Hext,[-1 0]) + circshift(Hext,[0 -1]) );
            
p = p(2:end-1, 2:end-1); 