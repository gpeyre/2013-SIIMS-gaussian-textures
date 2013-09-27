function Y = matlab_fig2latex(filename)
%
%
%  remove the boundary area of the fugures produced by Matlab
%
%  (C) Gui-Song Xia

I = imread(filename);
I = double(I);

[m n c] = size(I);

meanImg = @(I) mean(mean(I,1),2);

mY1 = 1; 
for mY1 = 1: 4: m
    if meanImg(I(1:mY1, :, :)) ~= I(mY1, fix(n/2), :); 
       break;
    end
end

for mY2 = m: -4: 1
    if meanImg(I(mY2:end, :, :)) ~= I(mY2, fix(n/2), :); 
       break;
    end
end

for nY1 = 1: 4: n
    if meanImg(I(:,1:nY1, :)) ~= I(fix(m/2), nY1, :); 
       break;
    end
end

for nY2 = n: -4: 1
    if meanImg(I(:, nY2:end, :)) ~= I(fix(m/2), nY2, :); 
       break;
    end
end

Y = uint8(I(mY1:mY2, nY1:nY2, :));
imwrite(Y, filename, filename(end-2:end));