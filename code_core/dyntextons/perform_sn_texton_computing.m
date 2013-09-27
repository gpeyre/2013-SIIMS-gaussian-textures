function sn_texton = perform_sn_texton_computing(f0)
%
% Computing the Canonical SN textons
%
% G.-S. Xia (guisong.xia@whu.edu.cn)

[m, n, d, nf] = size(f0);
f0 = permute(f0, [1 2 4 3]);
fft3 = @(f) fft(fft(fft(f, [], 1),[], 2),[], 3);

F = fft3(f0);
F = reshape(F, [m*n*nf, d]);

K = zeros(m*n*nf, d, d);
absF = sum(F.^2, 2).^.5;
for k =1:d
    for j = 1:d
        K(:,k,j) = F(:,k).*F(:,j)./absF;
    end
end
K(1) = 0;

K = reshape(K, [m, n, nf, d*d]);
sn_texton = permute(K, [1 2 4 3]);


