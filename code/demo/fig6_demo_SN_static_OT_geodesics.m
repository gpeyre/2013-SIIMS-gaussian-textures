% demo for OT-mixing of SN 2 static texture models
% 
% For reproducing Figure 6.2 in the paper
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%   by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% Copyright (c) 2012 Gui-Song Xia
%

clear all;
close all;
clc;

addpath(genpath('../code_core'));

rep = '../data/';
save_rep = '../results/geodesic/';

fname = {{ 'wood.png', 'greenTextile.png'},...
         { 'bluejeans.png', 'drygrass.png'},...
         { 'bluefur.png', 'sand.png'},...
        };

%%
Nt = 7;
loadimage = @(filename) double(imread([rep filename]))/256;
fmean = @(f) mean(mean(f));

%%
for in1 = 1: length(fname)
    name0 = fname{in1}{1};
    name1 = fname{in1}{2};

    f0 = loadimage(name0);
    f1 = loadimage(name1);
    [m,n, nc] = size(f0);

   %% compute OT-geodesics
    for t = 0: Nt
        geodesic_t(t+1) = perform_textures_OTgeodesic_computing(f0, f1, t/Nt); 
    end

    %% synthesis from texton on the geodesic
    save_rep_temp = [save_rep 'Mix-' name0(1:end-4) '-' name1(1:end-4) '/'];
    for t = 0: Nt
        pha = exp(1i*angle(fft2(rand(m,n)))); 
        hatft = geodesic_t(t+1).hatft.*repmat(pha, [1 1 3]);
        ft = real(ifft2(hatft)) + repmat(geodesic_t(t+1).mean, [m, n, 1]);
        ft(ft>1) = 1;
        ft(ft<0) = 0;
        
        if ~exist(save_rep_temp)
            mkdir(save_rep_temp);
        end
        str = [save_rep_temp 'OT-geodesic-', name0(1:end-5) '-' name1(1:end-5) '-t-0-' num2str(t), '-1'];
        imwrite(uint8(ft*255), [str '.png'], 'png');
    end
end
