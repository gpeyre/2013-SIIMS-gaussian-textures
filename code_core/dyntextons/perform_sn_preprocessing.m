function [f f_MEAN] = perform_sn_preprocessing(f0)
%
% This function removes the mean of the texture and
% compute the periodic component of the texture
%
% guisong.xia@whu.edu.cn
% 
[m0, n0, ~, tau0] = size(f0);
f_MEAN = squeeze(mean(mean(mean(f0, 4),1),2));
X = f0 - permute(repmat(f_MEAN, [1, m0, n0, tau0]), [2 3 1 4]);
f = PeriodicComp_3d(X);

function p = PeriodicComp_3d(h)
%
%
% compute the periodic component of h
% 
[m, n, dm, nb] = size(h);

p = zeros(size(h));
for d = 1:dm
    Hhat = intLaplace(squeeze(h(:,:,d,:)));
    FHhat = fftn(Hhat);

    [X Y Z] = meshgrid(0:n-1, 0:m-1, 0:nb-1);
    FPhat = FHhat./(6 -2.*cos(2.*X*pi/n) -2.*cos(2.*Y*pi/m) -2.*cos(2.*Z*pi/nb));
    FPhat(1,1,1) = sum(sum(sum(h(:,:,d,:))));

    p(:,:,d,:) = reshape(real(ifftn(FPhat)), [m, n, 1, nb]);
end

function p = intLaplace(h)
% Compute the discrete Laplacian in the interior of the image domain
Hext = zeros(size(h)+2);
Hext(2:end-1, 2:end-1, 2:end-1) = h;
Hext(1,   2:end-1, 2:end-1) = h(1,  :,:);
Hext(end, 2:end-1, 2:end-1) = h(end,:,:);
Hext(2:end-1, end, 2:end-1) = h(:,end,:);
Hext(2:end-1, 1,   2:end-1) = h(:,1,  :);
Hext(2:end-1, 2:end-1, end) = h(:,:,end);
Hext(2:end-1, 2:end-1,   1) = h(:,:,  1);

p = 6.*Hext - (Hext([2:end,1],:,:) + Hext([end, 1:end-1],:,:) +...
               Hext(:,[2:end,1],:) + Hext(:,[end, 1:end-1],:) +...
               Hext(:,:,[2:end,1]) + Hext(:,:,[end, 1:end-1]) );
p = p(2:end-1, 2:end-1, 2:end-1); 
