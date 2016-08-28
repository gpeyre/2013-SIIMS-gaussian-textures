% demo for OT-mixing of AR 2 dynamic texture models
% 
% For reproducing Figure 6.3(b) in the paper
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

rep = ('../data/');
save_rep = '../results/geodesic/';

fname = {
        { 'waterfall3_exemplar.avi', 'fire_smoke_exemplar.avi' },...
        { 'snow2.avi',  'waterfall1_exemplar.avi'},...
        { 'snow2.avi', 'waterfall3_exemplar.avi'},...
        { 'waterfall1_exemplar.avi', 'waterfall3_exemplar.avi'},...
        };

%%
Nt = 7;
         
video_fft  = @(f) fft(fft(fft(permute(f, [1 2 4 3]),[],1),[],2),[],3);
video_ifft = @(f) permute(ifft(ifft(ifft(f,[], 3),[],2),[],1), [1 2 4 3]);

%%
for in1 = 1: length(fname)
        name0 = fname{in1}{1};
        name1 = fname{in1}{2};
        [f0,rate] = load_video([rep name0], 100);
        [f1,   ~] = load_video([rep name1], 100);
        
        sz = min(size(f0), size(f1));
        f0 = f0(1:sz(1), 1:sz(2), 1:sz(3), 1:sz(4));
        f1 = f1(1:sz(1), 1:sz(2), 1:sz(3), 1:sz(4));
        [m, n, nc, nf] = size(f0);
        opt.d = nc;
        opt.mE = m;          
        opt.nE = n; 
        opt.nF = nf+10;      
        
       %% compute OT-geodesics       
        [f0 f_MEAN0] = perform_ar_preprocessing(f0);
        [f1 f_MEAN1] = perform_ar_preprocessing(f1);

        ardyn_texton0 = perform_AR_dyntexton_computing(f0, 1);
        ardyn_texton1 = perform_AR_dyntexton_computing(f1, 1);

        save_rep_temp = [save_rep 'vMix-AR-' name0(1:end-4) '-' name1(1:end-4) '/'];
        for t = 0: Nt
            % compute OT-geodesics 
            rho = t/Nt;
            ardyn_texton_t = perform_ar_OTgeodesic_computing(ardyn_texton0, ardyn_texton1, rho);
            ardyn_texton_t.m = (1- rho).*f_MEAN0 + rho.*f_MEAN1;
            % Synthesis with AR texton
            f = perform_AR_dyntexton_synthesis(ardyn_texton_t, opt);            
            f(f<0) = 0;
            f(f>1) = 1;

            if ~exist(save_rep_temp)
                mkdir(save_rep_temp);
            end
            str = [save_rep_temp 'AR-OT-geodesic-', name0(1:end-4) '-' name1(1:end-4) '-t-0-' num2str(t), '-1', '.gif'];
            save_movieGIF(f(:,:,:,11:end), str, Inf, rate);
        end  
end
