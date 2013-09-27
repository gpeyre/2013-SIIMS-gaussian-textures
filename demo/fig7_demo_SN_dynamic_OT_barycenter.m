% demo for computing SN OT-barycenters of 3 videos.
% 
% For reproducing Figure 7.4 in the paper
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%   by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% For more details, refer to the Algorithm 5
%
% Copyright (c) 2012 Gui-Song Xia
%

clear all; 
close all;
clc;

addpath(genpath('../code_core'));

rep = '../data/';
save_rep = '../results/barycenter/dynamic_SN/';

spacetimeMean = @(f) mean(mean(mean(f, 4), 1), 2); 
zero_mean = @(f) bsxfun(@minus, f, mean(mean(mean(f, 4), 1), 2)); 
video_fft  = @(f) fft(fft(fft(permute(f, [1 2 4 3]),[],1),[],2),[],3);
video_ifft = @(f) permute(ifft(ifft(ifft(f,[], 3),[],2),[],1), [1 2 4 3]);

%% testing set
fname = {
    {'waterfall3_exemplar.avi', 'ocean_De_exemplar.avi', 'fire_smoke_exemplar.avi'}, ...
    {'waterfall3_exemplar.avi', 'waterfall1_exemplar.avi', 'snow2.avi'}, ...
    {'waterfall3_exemplar.avi', 'fire5_exemplar.avi', 'waterfall1_exemplar.avi'}
    };
  
%% barycenter computing
% geodesci path index
s  = 0:0.2:1;
nF = 88;

for in1 = 1: length(fname)
    if not(exist([save_rep 'set-' num2str(in1)]))
       mkdir([save_rep 'set-' num2str(in1)]);
    end
   %% prepare images
    numtextures = length(fname{in1});
    
    Mu =[]; ui=[];
    for in2 = 1:3 
       [f rate] = load_video([rep fname{in1}{in2}], nF);
%        [~, ~, ~, nf] = size(f);
%        nF = min(nF, nf);
%        nF = nF - mod(nF,2);
       f = f(1:2^5, 1:2^5, :, 1:nF);
       [rows, cols, channels, nf] = size(f);
                 
       str = [save_rep 'set-' num2str(in1) '/Original1-' fname{in1}{in2}(1:end-4)];
       %save_movie(f, str, [], [], rate);
       save_movieGIF(f, [str, '.gif'], Inf, rate);
       
       f = PeriodicComp_3d(f);       
       Mu = cat(2, Mu, squeeze( spacetimeMean(f))); % mean of each video
       f = zero_mean(f);                            % videos with zero mean
       tmp = video_fft(f);                          % FFT of each video
       ui = cat(3, ui, reshape(tmp(:, :, 1:nF/2+1, :), [rows*cols*(nF/2+1), 3])');       
       clear f tmp;
    end     
    
   %% barycenters on geodesci path 1
    ti = 1-s;
    tj = s/2;
    Lambda = [ti; tj; 1-ti-tj];
    for i = 1:size(Lambda,2)       
        lambda = Lambda(:,i)';
        
        Mulambda = Mu*lambda';
        Av = generateImageBarycenter_video(ui,lambda);
        fYbis = zeros(rows,cols, nf, channels);
        fYbis(:,:,1:nf/2+1,1) = reshape(Av(1,:,:), rows,cols,nf/2+1);   
        fYbis(:,:,1:nf/2+1,2) = reshape(Av(2,:,:), rows,cols,nf/2+1);   
        fYbis(:,:,1:nf/2+1,3) = reshape(Av(3,:,:), rows,cols,nf/2+1); 
        clear Av;
        for ix = 1:rows
            for jy = 1:cols
                for jt = 1: nf/2+1
                    fYbis(mod(rows-ix+1,rows)+1,mod(cols-jy+1,cols)+1,mod(nf-jt+1,nf)+1, :) = conj(fYbis(ix,jy,jt, :));  
                end
            end 
        end 
        Y = bsxfun(@plus, real(video_ifft(fYbis)), reshape(Mulambda,1,1,3,1));
        clear fYbis;
        Y(Y<0) = 0; Y(Y>1) = 1;
        
        
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
              '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), 'sn_path1'];
        save_movieGIF(Y, [str, '.gif'], Inf, rate);
    end 
    
   %% barycenters on geodesci path 1
    ti = s/2;
    tj = 1- s;
    Lambda = [ti; tj; 1-ti-tj];
    for i = 1:size(Lambda,2)       
        lambda = Lambda(:,i)';
        
        Mulambda = Mu*lambda';
        Av = generateImageBarycenter_video(ui,lambda);
        fYbis = zeros(rows,cols, nf, channels);
        fYbis(:,:,1:nf/2+1,1) = reshape(Av(1,:,:), rows,cols,nf/2+1);   
        fYbis(:,:,1:nf/2+1,2) = reshape(Av(2,:,:), rows,cols,nf/2+1);   
        fYbis(:,:,1:nf/2+1,3) = reshape(Av(3,:,:), rows,cols,nf/2+1); 
        clear Av;
        for ix = 1:rows
            for jy = 1:cols
                for jt = 1: nf/2+1
                    fYbis(mod(rows-ix+1,rows)+1,mod(cols-jy+1,cols)+1,mod(nf-jt+1,nf)+1, :) = conj(fYbis(ix,jy,jt, :));  
                end
            end 
        end 
        Y = bsxfun(@plus, real(video_ifft(fYbis)), reshape(Mulambda,1,1,3,1));
        clear fYbis;
        Y(Y<0) = 0; Y(Y>1) = 1;
        
        
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
              '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), 'sn_path2'];
        save_movieGIF(Y, [str, '.gif'], Inf, rate);
    end 
end