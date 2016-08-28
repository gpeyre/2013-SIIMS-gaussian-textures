function geodesicT = perform_textures_OTgeodesic_computing(f0, f1, t) 
% computing the OT-geodesic of SN texture models
%
% Gui-Song Xia gsxia.lhi@gmail.fr
% 

[m,n, nc] = size(f0);

f0 = PeriodicComp(f0);
f1 = PeriodicComp(f1);

fmean = @(f) mean(mean(f));

Mean0 = fmean(f0);
Mean1 = fmean(f1);
f0 = f0 - repmat(Mean0, [m, n, 1]);
f1 = f1 - repmat(Mean1, [m, n, 1]);

%% FFT
hatf0 = reshape(fft2(f0), m*n, nc);
hatf1 = reshape(fft2(f1), m*n, nc);

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
hatft = reshape(hatft, m, n, nc);

geodesicT.mean  = Meant;
geodesicT.hatft = hatft;
