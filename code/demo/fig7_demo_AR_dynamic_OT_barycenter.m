% demo for computing AR OT-barycenters of 3 videos.
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
save_rep = '../results/barycenter/dynamic_AR/';

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
% use s for geodesci path indexing
s  = 0:0.2:1;
nf = 88;

for in1 = 2: length(fname)
    if not(exist([save_rep 'set-' num2str(in1)]))
       mkdir([save_rep 'set-' num2str(in1)]);
    end
   %% prepare videos
    numtextures = length(fname{in1});
    
    Mu =[]; 
    for in2 = 1:numtextures
       [f rate] = load_video([rep fname{in1}{in2}], nf);
       f = f(1:2^5, 1:2^5, :, :);
       [rows, cols, channels, nf] = size(f);
                 
       str = [save_rep 'set-' num2str(in1) '/Original1-' fname{in1}{in2}(1:end-4)];
       %save_movie(f, str, [], [], rate);
       save_movieGIF(f, [str, '.gif'], Inf, rate);
       
      %% Step 1) Pre-processing for each video      
       [f, f_MEAN] = perform_ar_preprocessing(f);
       
      %% Step 2) AR-texton learning for each video        
       ardyn_texton(in2).ar = perform_AR_dyntexton_computing(f, 1);
       Mu(:, in2) = f_MEAN; 
       clear f;
    end     
    
    % parameters for synthesis 
    opt.d = channels;
    opt.mE = rows;          
    opt.nE = cols; 
    opt.nF = nf+10;      
    
   %% barycenters on geodesic path 1
    ti = 1-s;
    tj = s/2;
    Lambda = [ti; tj; 1-ti-tj];
    
    for i = 1:size(Lambda,2)       
        lambda = Lambda(:,i)';
        
       %% Step 3) computing AR OT-barycenter mixing
        ardyn_texton_t = perform_ar_OTbarycenter_computing(ardyn_texton, lambda);
        ardyn_texton_t.m = Mu*lambda';
        
       %% Step 4) Synthesizing with mixed AR-texton
        f = perform_AR_dyntexton_synthesis(ardyn_texton_t, opt);            
        f(f<0) = 0;  f(f>1) = 1;
        
        % save results
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
             '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), 'ar_path1'];
        save_movieGIF(f, [str, '.gif'], Inf, rate);
    end     
    
    %% barycenters on geodesic path 2
    ti = s/2;
    tj = 1-s;
    Lambda = [ti; tj; 1-ti-tj];
    
    for i = 1:size(Lambda,2)       
        lambda = Lambda(:,i)';
        
       %% Step 3) computing AR OT-barycenter mixing
        ardyn_texton_t = perform_ar_OTbarycenter_computing(ardyn_texton, lambda);
        ardyn_texton_t.m = Mu*lambda';
        
       %% Step 4) Synthesizing with mixed AR-texton
        f = perform_AR_dyntexton_synthesis(ardyn_texton_t, opt);            
        f(f<0) = 0;  f(f>1) = 1;
        
        % save results
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
             '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), 'ar_path2'];
        save_movieGIF(f, [str, '.gif'], Inf, rate);
    end  
end