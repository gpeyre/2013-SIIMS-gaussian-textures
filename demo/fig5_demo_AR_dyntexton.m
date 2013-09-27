% demo on AR dyntexton synthesizing
% 
% For reproducing Figure 5.1(c) in the paper
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
name = 'waterfall_De_exemplar2.avi';
%name = 'goldenlines_exemplar.avi';

%% load video data
[f rate] = load_video([rep name], 100);
[m, n, d, nf] = size(f);

%%% Set parameters for synthesis
opt.d = d;
opt.mE = ceil(m*1.);          
opt.nE = ceil(n*1.); 
opt.nF = nf;          

%% Preprocessing
[f0 f_MEAN] = perform_ar_preprocessing(f);

%% Computing AR texton
ar_texton = perform_AR_dyntexton_computing(f0, 1);
ar_texton.m = f_MEAN;

%% Synthesis with AR texton
f0 = perform_AR_dyntexton_synthesis(ar_texton, opt);

%% Save synthesized video
save_movieGIF(f0, [save_rep, name(1:end-4), '_AR_syn.gif'], Inf, rate);
%figure; display_video2(f, f0, 2);


%% Show diagonal elements of [(A,L)_r,r, (A,L)_g,g, (A,L)_b,b] of the 2D AR texton
fftshift2 = @(f)  fftshift(fftshift(f, 1), 2);

AR_A = fftshift2(real(ifft2(ar_texton.a{1})));
AR_L = fftshift2(real(ifft2(ar_texton.sigWp)));
diag_A = cat(3, AR_A(:,:,1,1), AR_A(:,:,2,2), AR_A(:,:,3,3));
diag_L = cat(3, AR_L(:,:,1,1), AR_L(:,:,2,2), AR_L(:,:,3,3));

figure; imshow(diag_A); 
figure; imshow(diag_L); 
imwrite(diag_A, [save_rep, name(1:end-4), 'AR_texton', 'A', '.png']);
imwrite(diag_L, [save_rep, name(1:end-4), 'AR_texton', '_L','.png']);