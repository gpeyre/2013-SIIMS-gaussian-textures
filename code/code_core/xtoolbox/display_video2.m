function display_video2(f0, f, r)

if nargin<3
    r = 1e3; 
end

f = f/max(f(:));
f0 = f0/max(f0(:));

if size(f,4)==1
    % grayscale video
    f = reshape(f, [size(f,1) size(f,2) 1 size(f,3)]);
end

if size(f0,4)==1
    % grayscale video
    f0 = reshape(f0, [size(f0,1) size(f0,2) 1 size(f0,3)]);
end

length_f = size(f,4);
length_f0 = size(f0,4);

clf;
warning off all;
for k=1:r
    for i=1: max(length_f0, length_f)
        if i > length_f0
            f0_i = length_f0;
        else
            f0_i = i;
        end
        if i > length_f
            f_i = length_f;
        else
            f_i = i;
        end
        subplot(121); imagesc(f0(:,:,:,f0_i)); axis image; axis off; 
        subplot(122); imagesc(f(:,:,:,f_i)); axis image; axis off; 
        if size(f,3)==1
            colormap gray(256);
        end
        drawnow;
        pause(1/30);
    end
end