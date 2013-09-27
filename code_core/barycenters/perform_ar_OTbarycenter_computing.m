function ardyn_texton_t = perform_ar_OTbarycenter_computing(ardyn_texton, lambda)
%
% perform_ar_OTbarycenter_computing - computing AR OT-barycenter 
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%    by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% Copyright (c) 2012 Gui-Song Xia

%%
afw0 = ardyn_texton(1).ar.a{1};
sig0 = ardyn_texton(1).ar.sigWp;
afw1 = ardyn_texton(2).ar.a{1};
sig1 = ardyn_texton(2).ar.sigWp;
afw2 = ardyn_texton(3).ar.a{1};
sig2 = ardyn_texton(3).ar.sigWp;

[m, n, d1, d2] = size(afw1); 
afwM = zeros(m, n, d1, d2); 
sigM = zeros(m, n, d1, d2); 

%% function handles

% a, b are dxd matrix
d = d1;
numVideo = 3;

gamma = @(a, b) [beta(a,b)    a*beta(a,b); ...
                 beta(a,b)*a' beta(a,b)]; 
inVgamma = @(u) [u(1:d,d+1:2*d)*pinv(u(1:d,1:d)), ...
                 u(1:d,1:d)-u(1:d,d+1:2*d)*(pinv(u(1:d,1:d)))*(u(1:d,d+1:2*d))']; 
T   = @(s0, s1) sqrtm(s1)* pinv( sqrtm( sqrtm(s1)*s0*sqrtm(s1) )) *sqrtm(s1);
Tt  = @(t, s0, s1) (1-t)*eye(2*d) + t*T(s0, s1); 
gat = @(t, s0, s1) Tt(t, s0, s1)*s0*Tt(t, s0, s1);
aBt = @(t, s0, s1) inVgamma(gat(t, s0, s1));

%% 
ga = zeros(2*d, 2*d, m, n, numVideo);

for i=1:m
    for j =1:n
        ga(:,:,i,j,1) = gamma(squeeze(afw0(i,j,:,:)), squeeze(sig0(i,j,:,:)));
        ga(:,:,i,j,2) = gamma(squeeze(afw1(i,j,:,:)), squeeze(sig1(i,j,:,:)));
        ga(:,:,i,j,3) = gamma(squeeze(afw2(i,j,:,:)), squeeze(sig2(i,j,:,:)));
    end
end
ga = reshape(ga, [2*d, 2*d, m*n, numVideo]);
S = ga(:,:,:,1);

disp(['Computing...'])
tic;
S = parallel_compute_gaussian_mapping6x6(S, ga, lambda);
disp(['time:' num2str(toc) ]);

S = reshape(S, [2*d, 2*d, m, n]);
for i=1:m
    for j =1:n
       temp = inVgamma(squeeze(S(:,:,i,j)));
       afwM(i,j,:,:) = temp(1:d,1:d); 
       sigM(i,j,:,:) = real(temp(1:d, d+1:2*d)).^0.5;
    end
end

ardyn_texton_t.a{1} = afwM;
ardyn_texton_t.sigWp = sigM;


function be = beta(a, b)
%
% solve the the euqation: be - a*be*a' = b.*conj(b)
%

[S, E] = eig(a);
invS = pinv(S);
B = invS*(b.*conj(b))*invS';

diagE = diag(E);
sig = B./(1-diagE*diagE');
be = S*sig*S';