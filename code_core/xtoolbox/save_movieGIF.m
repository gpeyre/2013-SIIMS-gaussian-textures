function save_movieGIF(X, fname, LoopCounts, rate)
%
%
%

Timedelay = 1/rate;

M = [];
[M(:,:,1,1), map] = rgb2ind(X(:,:,:,2), 256); % compute the colormap for the first frame
for i=2:size(X,4)
    [M(:,:,1,i),map] = rgb2ind(X(:,:,:,i), map);    
end
imwrite(M+1, map, fname, 'DelayTime',Timedelay, 'loopcount', LoopCounts);