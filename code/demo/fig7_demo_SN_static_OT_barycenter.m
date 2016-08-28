% demo for computing SN OT-barycenters of 3 static texture images.
% 
% For reproducing Figure 7.3 in the paper
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
save_rep = '../results/barycenter/static_SN/';

loadimage = @(filename) double(imread([rep filename]))/256;

%% testing set
fname = {
    {'drygrass.png', 'bluejeans.png', 'sand.png'}, ...
    {'piedra.png', 'wood.png', 'green_fabric.png'}, ...
    {'sky.png', 'sea.png', 'bluejeans.png'}, ...
    };
  
%% barycenter computing
% geodesci path index
s  = 0:0.2:1;

for in1 = 1: length(fname)
    if not(exist([save_rep 'set-' num2str(in1)]))
       mkdir([save_rep 'set-' num2str(in1)]);
    end
    %% prepare images
    images = [];
    for in2 = 1:3 
       temp = PeriodicComp(loadimage(fname{in1}{in2}));
       images = cat(4, images, temp);
    end  
    Mu = mean(mean(images));
    [m, n, d, numtextures] = size(images);

    ui = reshape(fft2(images - repmat(Mu, [m, n, 1, 1])), m*n, d, numtextures);
    ui = permute(ui, [2 1 3]);
    
    
   %% barycenters on geodesci path 1
    ti = 1-s;
    tj = s/2;
    Lambda = [ti; tj; 1-ti-tj];
    for i = 1:size(Lambda,2)       
        lambda = Lambda(:,i)';
        YY = generateImageBarycenter(ui, lambda, squeeze(Mu), m, n);
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
              '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), '_path1.png'];
        imwrite(YY,str);
    end 
    
   %% barycenters on geodesci path 2
    ti = s/2;
    tj = 1-s;
    Lambda = [ti; tj; 1-ti-tj];

    for i = 1:size(Lambda,2)
        lambda = Lambda(:,i)';
        YY = generateImageBarycenter(ui, lambda, squeeze(Mu), m, n);
        str = [save_rep 'set-' num2str(in1) '/', num2str(i), ...
             '-' fname{in1}{1}(1:end-4) num2str(lambda(1)*10),...
             '-' fname{in1}{2}(1:end-4) num2str(lambda(2)*10),...
              '-' fname{in1}{3}(1:end-4) num2str(lambda(3)*10), '_path2.png'];
        imwrite(YY,str);
    end 
end