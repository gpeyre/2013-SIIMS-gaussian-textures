function ardyn_texton_t = perform_ar_OTgeodesic_computing(ardyn_texton0, ardyn_texton1, Rho)
%
% mixing AR(1) models with optimal transport
% G.-S. xia (guisong.xia@whu.edu.cn)
%

%%
afw0 = ardyn_texton0.a{1};
sig0 = ardyn_texton0.sigWp;
afw1 = ardyn_texton1.a{1};
sig1 = ardyn_texton1.sigWp;

[m, n, d1, d2] = size(afw1); 
afwM = zeros(m, n, d1, d2); 
sigM = zeros(m, n, d1, d2); 

%% function handles

% a, b are dxd matrix
d = d1;

gamma = @(a, b) [beta(a,b)    a*beta(a,b); ...
                 beta(a,b)*a' beta(a,b)]; 
inVgamma = @(u) [u(1:d,d+1:2*d)*pinv(u(1:d,1:d)), ...
                 u(1:d,1:d)-u(1:d,d+1:2*d)*(pinv(u(1:d,1:d)))*(u(1:d,d+1:2*d))']; 
T   = @(s0, s1) sqrtm(s1)* pinv( sqrtm( sqrtm(s1)*s0*sqrtm(s1) )) *sqrtm(s1);
Tt  = @(t, s0, s1) (1-t)*eye(2*d) + t*T(s0, s1); 
gat = @(t, s0, s1) Tt(t, s0, s1)*s0*Tt(t, s0, s1);
aBt = @(t, s0, s1) inVgamma(gat(t, s0, s1));

%% 
for i=1:m
    for j =1:n
        ga1 = gamma(squeeze(afw0(i,j,:,:)), squeeze(sig0(i,j,:,:)));
        ga2 = gamma(squeeze(afw1(i,j,:,:)), squeeze(sig1(i,j,:,:)));
        temp = aBt(Rho, ga1, ga2);
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