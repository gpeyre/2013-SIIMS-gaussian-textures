function ardyn_texton = perform_AR_dyntexton_computing(X, orderP)
%
% compute_AR_dyntexton: compute the AR-dyntex-ton of color dynamic textures
%
% Input: X        : exemplar color texture video
%        orderP   : order of the AR(p) processes
%        vSize    : the size of the AR-dyntex-ton
% Output: ardyn_texton.a       : coefficients matries of the AR(p) processes
%         ardyn_texton.sigWp   : the std of the gaussian noise
%         ardyn_texton.order   : orderP
%         ardyn_texton.m       : mean of textures
%    The dynamic texture is represented as 
%       $$ 
%           X_{t+1} =  \sum_{k=1}^p a_{k} \star X_{t-k} + sigWp \star W_{t}
%       $$
%
%  Gui-Song Xia (gsxia.lhi@gmail.com)
%  Dec 15, 2011
%

if orderP ~= 1
    orderP = 1;  % for AR(1) model
end

[Ap sigWp] = AR1FFT_color_fit(X);
    
%Ap = fftshift2(Ap);
%sigWp = fftshift2(sigWp);

ardyn_texton.a{1} = Ap;
ardyn_texton.sigWp = sigWp;
ardyn_texton.order = orderP;


function [ah SigW] = AR1FFT_color_fit(f)
%
% Function: spatial stationary color AR(1) processes for modeling dynamic textures
%
%   Oberve that the mean of the dynamic texture should be zero, otherwise
%   the mean will be removed form the input.
%
% Input: f        : exemplar texture video with zero means
%        tau1     : the number of frames of the synthesized one
% Output: f       : synthesized dynamic texture with length tau1
%         ah      : coefficients matries of the color AR(1) processes
%         SigW    : the std of the color gaussian noise
%
%  Gui-Song Xia (gsxia.lhi@gmail.com)
%  Dec 10, 2011

%%
[m0, n0, nc, tau0] = size(f);

%% 2D fft
F0 = fft2(f);

%% solve color Yule-Walker equations 
Fa = reshape(F0(:,:,:,2:end), m0*n0, nc, tau0-1);
Fb = reshape(F0(:,:,:,1:end-1), m0*n0, nc, tau0-1);
h = zeros(m0*n0, 3,3);
SigW = zeros(m0*n0, 3,3);
for i = 1: m0*n0
   xt1 = squeeze(Fa(i,:,:));
   xt0 = squeeze(Fb(i,:,:));
   tmp = xt1*xt0'*pinv(xt0*xt0');
   h(i,:,:) = tmp;
   SigW(i,:,:) = (xt1 - tmp*xt0)*(xt1 - tmp*xt0)'./(tau0-1);
end
SigW = real(SigW).^0.5;

ah = reshape(h, m0, n0, nc, nc);

SigW = reshape(SigW, m0, n0, nc, nc);