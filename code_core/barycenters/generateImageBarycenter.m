function YY = generateImageBarycenter(ui,lambda,Mu,rows,cols)
%
%
%
% ui: dimensions: 3,rows*cols,num_textures

%Iterative SpotNoise each channel independently

Mulambda = Mu*lambda';

%Fix-Point equation in vectorial form

disp(['Computing...'])

tic

[fyv, Av] = FixPointMixVector(ui,lambda, rows,cols);
Y  = ifft2(fyv);
YY = real(Y) + repmat(reshape(Mulambda,1,1,3),[rows cols 1]);

disp(['Vectorial:' num2str(toc) ]);







 




