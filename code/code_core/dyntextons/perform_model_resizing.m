function ex_texton = perform_model_resizing(texton, opt)
%
% perform model resizing
%

fftshift3 = @(f) fftshift(fftshift(fftshift(f,3),2),1);
ifftshift3 = @(f) ifftshift(ifftshift(ifftshift(f,1),2),3);
permuteST = @(f) permute(f, [1 2 4 3]); 

mE = opt.mE;
nE = opt.nE;
nF = opt.nF;

[m,n,d,nf] = size(texton); 
ex_texton = zeros(mE, nE, nF, d);

lft = ceil(.5*(mE-m)); 
top = ceil(.5*(nE-n)); 

%pre = ceil(.5*(nT-nb)); 
if lft==0 & top ==0
    ex_texton = permuteST(texton);
else
   ex_texton(lft+1:lft+m, top+1:top+n, 1:nf, :) = fftshift3(permuteST(texton));
   ex_texton = ifftshift3(ex_texton);
end
ex_texton = reshape(ex_texton, [mE*nE*nF, d^.5, d^.5]);