function display_video(f,r)
%
%
% display a video r times

if nargin<2
    r = 1e3; 
end

f = f/max(f(:));

if size(f,4)==1
    % grayscale video
    f = reshape(f, [size(f,1) size(f,2) 1 size(f,3)]);
end

clf;
warning off all;
for k=1:r
    for i=1:size(f,4)
        imshow(f(:,:,:,i)); axis image; axis off; 
        if size(f,3)==1
            colormap gray(256);
        end
        drawnow;
        pause(2/25);
    end
end