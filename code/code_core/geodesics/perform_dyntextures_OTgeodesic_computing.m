function geodesicT = perform_dyntextures_OTgeodesic_computing(f0, f1, t) 
% test texture mixing using OT
%
% Gui-Song Xia gsxia.lhi@gmail.fr
% 
[m, n, nc, nf] = size(f0);

spacetimeMean = @(f) mean(mean(mean(f, 4), 1), 2); 
zero_mean = @(f) bsxfun(@minus, f, mean(mean(mean(f, 4), 1), 2)); 
video_fft  = @(f) fft(fft(fft(permute(f, [1 2 4 3]),[],1),[],2),[],3);

% compute the periodic components   
f0 = PeriodicComp_3d(f0);
f1 = PeriodicComp_3d(f1);
Mean0 = spacetimeMean(f0);
Mean1 = spacetimeMean(f1);

% videos with zero mean
f0 = zero_mean(f0);
f1 = zero_mean(f1);
    
%% FFT
hatf0 = reshape(video_fft(f0), m*n*nf, nc);
hatf1 = reshape(video_fft(f1), m*n*nf, nc);

%% parallel implementation of the following parts

multM3component = @(u1, u0) u1(:,1).*u0(:,1) + u1(:,2).*u0(:,2)+ u1(:,3).*u0(:,3);  
u1 = conj(hatf1); 
u0 = conj(hatf0); 

a = multM3component(conj(u1), u0);
b = repmat(a,[1 3]).*u1;
hatg = b./abs(repmat(a,[1 3]));

%% OT-geodesic 
Meant = (1- t).*Mean0 + t.*Mean1;

hatft = (1- t).*hatf0 + t.*hatg;
hatft = reshape(hatft, m, n, nf, nc);

geodesicT.mean  = Meant;
geodesicT.hatft = hatft;
