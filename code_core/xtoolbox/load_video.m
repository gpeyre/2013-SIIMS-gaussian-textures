function [f rate] = load_video(dirname, nbframe)

v = mmread(dirname);
p = min(nbframe, v.nrFramesTotal);
s = size(v.frames(1).cdata);
f = zeros([s p]);
for i=1:p
    f(:,:,:,i) = v.frames(i).cdata;
end
f = f./255;
rate = v.rate;