% demo for OT-mixing of SN 2 dynamic texture models
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

        %% compute OT-geodesics 
         for t = 0: Nt
           geodesic_t(t+1) = perform_dyntextures_OTgeodesic_computing(f0, f1, t/Nt); 
         end

        %% synthesis from texton on the geodesic

         ft_list = zeros(m, n, nf, nc);
         save_rep_temp = [save_rep 'vMix-SN-' name0(1:end-4) '-' name1(1:end-4) '/'];
         for t = 0: Nt
            pha = exp(1i*angle(video_fft(rand(m, n, 1, nf)) )); 
            hatft = geodesic_t(t+1).hatft.*repmat(pha, [1 1 1 3]);
            ft_list = bsxfun(@plus, real(video_ifft(hatft)), geodesic_t(t+1).mean);
            ft_list(ft_list<0) = 0;
            ft_list(ft_list>1) = 1;

            if ~exist(save_rep_temp)
                mkdir(save_rep_temp);
            end
            str = [save_rep_temp 'SN-OT-geodesic-', name0(1:end-4) '-' name1(1:end-4) '-t-0-' num2str(t), '-1', '.gif'];
            save_movieGIF(ft_list, str, Inf, rate);
            %saveFrames(ft_list, str, 3, 1, []);
         end
end

