function saveFrames(V, filename, numF, first, method)
%
%
% save numF frames of the video V as images
%

for i = first: first+numF-1
    if ~isempty(method)
        imwrite(uint8(V(:,:,:,i)*255), cat(2, filename(1:end-4), method,  num2str(i), '.png'));
    else
        imwrite(uint8(V(:,:,:,i)*255), cat(2, filename(1:end-4), num2str(i), '.png'));
    end
end