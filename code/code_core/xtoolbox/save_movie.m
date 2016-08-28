function save_movie(M, save_rep, name, flag_method, rate)
%
%
%

if size(M,4)==1
    % grayscale video
    M = reshape(M, [size(M,1) size(M,2) 1 size(M,3)]);
end

video_synth = immovie(M); 

movie2avi(video_synth, [save_rep name(1:end-4) '_' flag_method '.avi'], 'fps', rate, 'compression', 'None');