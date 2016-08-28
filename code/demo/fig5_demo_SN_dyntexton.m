% demo on SN dyntexton synthesizing
% 
% For reproducing Figure 5.1(b) in the paper
%
% "Synthesizing and Mixing Stationary Gaussian Texture Models"
%   by Gui-Song Xia, Sira Ferradans, Gabriel Peyre and Jean-Francois Aujol
%  http://hal.archives-ouvertes.fr/hal-00816342.
%
% Copyright (c) 2012 Gui-Song Xia
%

close all;
clear all;
clc;

addpath(genpath('../code_core'));

rep = '../data/';
save_rep = '../results/dyntextons/';

%name = 'waterfall1_exemplar.avi';
%name = 'clouds_original.mpg'; 
%name = 'ocean_exemplar.avi';
%name = 'snow2.avi';
%name = 'waterfall3_exemplar.avi';
%name = 'waterfall_De_exemplar2.avi';
name = 'goldenlines_exemplar.avi';

%% load video data
[f rate] = load_video([rep name], 100);
[m, n, d, nf] = size(f);

%%% Set parameters for synthesis
opt.d = d;
opt.mE = ceil(m*1.);          
opt.nE = ceil(n*1.); 
opt.nF = nf;            

%% Preprocessing
[f0 f_MEAN] = perform_sn_preprocessing(f);

save_movieGIF(f, [save_rep, name(1:end-4), '_Original.gif'], Inf, rate);

%% SN texton-computing 
sn_texton = perform_sn_texton_computing(f0);

%% Model resizing
resize_texton = perform_model_resizing(sn_texton, opt);

%% SN texton
f0 = perform_sn_synthesis(resize_texton, f_MEAN, opt, 0);
save_movieGIF(f0, [save_rep, name(1:end-4), '_SN_syn.gif'], Inf, rate);

% save 3D SN texton
f0 = perform_sn_synthesis(resize_texton, f_MEAN, opt, 1);
save_movieGIF(f0, [save_rep, name(1:end-4), '_sn_texton.gif'], Inf, rate);

%% display video
% display_video2(f, f0, 2);

numF = floor(nf/2);

% show and save 
figure; imshow(f0(:,:,:,numF), []);
figure; imshow(f0(:,:,:,numF+1), []);
imwrite(f0(:,:,:,numF), [save_rep, name(1:end-4), 'sn_texton', num2str(numF), '.png']);
imwrite(f0(:,:,:,numF+1), [save_rep, name(1:end-4), 'sn_texton', num2str(numF+1), '.png']);