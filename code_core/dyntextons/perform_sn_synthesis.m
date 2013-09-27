function f = perform_sn_synthesis(resize_texton, f_MEAN, opt, flag)
%
%
% 
% flag == 1: output dyntexton
%      == 0: output synthesized video
%
% G.-S. Xia (guisong.xia@whu.edu.cn)

fft3      = @(f) fft(fft(fft(f, [], 1),[], 2),[], 3);
ifft3     = @(f) ifft(ifft(ifft(f, [], 3),[], 2),[], 1);
fftshift3 = @(f) fftshift(fftshift(fftshift(f,3),2),1);

mE = opt.mE;
nE = opt.nE;
nF = opt.nF;
d = opt.d;

W = randn(mE, nE, d, nF);
W = permute(W, [1 2 4 3]);
Wf = fft3(W);

Wf = reshape(Wf, mE*nE*nF, d);

F = zeros(size(Wf));
for k =1:d
   if flag == 0
        F(:,k) = sum(squeeze(resize_texton(:,k,:)).*Wf, 2)./(mE*nE*nF).^.5;
   else
        F(:,k) = squeeze(resize_texton(:,k,k));
   end
end
F(1,:) = f_MEAN*mE*nE*nF;
F = reshape(F, [mE, nE, nF, d]);
f = real(ifft3(F));

if flag == 1
   f = fftshift3(f);
end

f = permute(f, [1 2 4 3]); 
f(f>1) = 1;
f(f<0) = 0;