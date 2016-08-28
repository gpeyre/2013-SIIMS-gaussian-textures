function Y = perform_AR_dyntexton_synthesis(ardyn_texton, opt)
%
% synthesis_AR_dyntexton: synthesis color dynamic texture using
% learned AR-dyntex-ton and PCA mapping of colors
%   
% Oberve that AR-dyntex-ton are learned by the function
% "compute_AR_dyntexton", which computing the AR-dyntex-tons by removing
% the mean form the input. 
%
% Input:  ardyn_texton.a       : coefficients matries of the AR(p) processes
%         ardyn_texton.sigWp   : the std of the gaussian noise
%         ardyn_texton.order   : order of the AR(p) processes
%         ardyn_texton.U       : color mapping
%               mE, nE         : spatial size of the synthesized video
%                   nF         : time size of the sunthesized video
% Output: Y        : synthesized video
%         
%    The dynamic texture is represented as 
%       $$ 
%           X_{t+1} =  \sum_{k=1}^p a_{k} \star X_{t-k} + sigWp \star W_{t}
%       $$
%
%  Gui-Song Xia (gsxia.lhi@gmail.com)
%  Dec 15, 2011

% read dyn-textons
Ap     = ardyn_texton.a;
f_MEAN = ardyn_texton.m;
sigWp  = ardyn_texton.sigWp;


mE = opt.mE;
nE = opt.nE;
nF = opt.nF;
nc = opt.d; % color images

p = 1;  % for AR(1) 

% initialization
Y = zeros(mE, nE, nc, nF);
R = randn(mE, nE, nc, nF)./((mE*nE)^.5);

R = fft2(R);
% synthesis 
for i = p+1: nF
     for c = 1: nc
        for k = 1:p
            Y(:,:,c,i) = Y(:,:,c,i) + ...
                Y(:,:,1,i-k).*Ap{k}(:,:,c,1)+ ...
                Y(:,:,2,i-k).*Ap{k}(:,:,c,2)+...
                Y(:,:,3,i-k).*Ap{k}(:,:,c,3); 
        end
            Y(:,:,c,i) = Y(:,:,c,i) + ...
                R(:,:,1,i-k).*sigWp(:,:,c,1)+ ...
                R(:,:,2,i-k).*sigWp(:,:,c,2)+...
                R(:,:,3,i-k).*sigWp(:,:,c,3); 
    end
end

Y = real(ifft2(Y)) + permute(repmat(f_MEAN, [1, mE, nE, nF]), [2 3 1 4]);

Y(Y<0) = 0;
Y(Y>1) = 1;