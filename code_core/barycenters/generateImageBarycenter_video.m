function Av = generateImageBarycenter_video(ui,lambda)
% ui: dimensions: 3, rows*cols*nf, num_textures

% Iterative SpotNoise each channel independently
% Mulambda = Mu*lambda';

%Fix-Point equation in vectorial form

disp(['Computing...'])

%Y = ifft2(FixPointMixVector(ui,lambda, rows,cols));
%YY = real(Y) + repmat(reshape(Mulambda,1,1,3),[rows cols 1]);


%%test
tic

Av = FixPointMixVector_video(ui, lambda);
% Y = ifft2(fyv);
% YY = real(Y) + repmat(reshape(Mulambda,1,1,3),[rows cols 1]);

disp(['Vectorial:' num2str(toc) ]);

% tic
% 
% [fy,A]  =FixPointMix(ui,lambda, rows,cols);
% Y = ifft2(fy);
% YYprev = real(Y) + repmat(reshape(Mulambda,1,1,3),[rows cols 1]);
% 
% disp(['Non-vectorial:' num2str(toc) ]);
% 
% subplot(2,1,1);imshow(YY)
% subplot(2,1,2);imshow(YYprev);







 




