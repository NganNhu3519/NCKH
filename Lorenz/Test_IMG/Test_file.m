%% FILE 1 — CS IMAGE (NO BLOCK-WISE)
close all; clear; clc;

imgH = 64; imgW = 64;
% Img_full = double(imread('cell.tif'));
Img_full = double(imread('riceblurred.png'));
Img = Img_full([1:imgH],[1:imgW]);

x = Img(:);
mu = mean(x);
sigma = std(x);
x = (x - mu) / sigma;

N = length(x);
psi = dctmtx(N);

M = 1800;
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);

y_cp = phi * x;

figure;
subplot(2,2,1);
imshow(uint8(Img));
title('Original image');

subplot(2,2,2);
plot(y_cp,'k');
title('CS measurements y');

subplot(2,2,3);
histogram(x,100);
title('Histogram of original image');

subplot(2,2,4);
histogram(y_cp,100);
title('Histogram of CS measurements');

% save('y_img_noblock_ver4.mat','phi','y_cp','mu','sigma');

%% File 3
close all; clear; clc;

load y_img_noblock_ver4.mat
load img_noblock_ver4.mat

y_use = x_est(4,:)';
y_use = y_use(:);

imgH = 64; imgW = 64;
Img_full = double(imread('riceblurred.png'));
% Img_full = double(imread('cell.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);
N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_use;
tic
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 20);
recon = toc;
x_hat = psi' * s_hat;
% x_hat_dn = x_hat * sigma + mu;
 x_hat_dn = x_hat * std(x_true) + mean(x_true);
Img_hat = reshape(x_hat_dn, size(Img));

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image'); %(no block-wise)

Img_arr = x_true;
x_hat_v = x_hat_dn(:);

mse1 = mse(x_hat_v, Img_arr);
peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
R1  = corrcoef(Img_arr, x_hat_v);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB| CC=%.6f\n',mse1, psnr1, CC1);

%% File 3 test
close all; clear; clc;
imgH = 64; imgW = 64;
Img_full = double(imread('cell.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);

load y_img_noblock_ver3.mat

N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_cp;
tic
s_hat = l1eq_pd(s0, Theta, Theta', y_cp, 5e-3, 20);
recon = toc;
x_hat = psi' * s_hat;
x_hat_dn = x_hat * std(x_true) + mean(x_true);
Img_hat = reshape(x_hat_dn, size(Img));

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image'); %(no block-wise)

Img_arr = x_true;
x_hat_v = x_hat_dn(:);

mse1 = mse(x_hat_v, Img_arr);
peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
R1  = corrcoef(Img_arr, x_hat_v);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', ...
        mse1, psnr1, snr1, CC1);

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image'); %(no block-wise)

%%
close all; clear; clc;

% files = {'mri.tif','cell.tif','riceblurred.png'};
 files = {'cameraman.tif'};
for k = 1:length(files)
    fprintf('\n===== TEST IMAGE: %s =====\n', files{k});

    Img = double(imread(files{k}));
    if ndims(Img) == 3
        Img = rgb2gray(uint8(Img));
        Img = double(Img);
    end

    [H,W] = size(Img);
    x = Img(:);

    figure;
    subplot(2,2,1);
    imshow(Img,[]);
    title(sprintf('%s (%dx%d)',files{k},H,W));

    subplot(2,2,2);
    histogram(x,100);
    title('Histogram');

    [Gx,Gy] = gradient(Img);
    tv_energy = mean(abs(Gx(:)) + abs(Gy(:)));

    dc_ratio = abs(mean(x)) / std(x);

    m = round(0.3 * numel(x));
    phi = randn(m, numel(x));
    y = phi * x;
    x_bp = phi' * y;
    R = corrcoef(x, x_bp);
    cs_cc = R(1,2);

    subplot(2,2,3);
    imagesc(abs(Gx)+abs(Gy)); axis image off;
    title('Gradient magnitude');

    subplot(2,2,4);
    text(0.05,0.8,sprintf('TV energy = %.3f',tv_energy),'FontSize',11);
    text(0.05,0.6,sprintf('DC ratio = %.3f',dc_ratio),'FontSize',11);
    text(0.05,0.4,sprintf('CS CC = %.3f',cs_cc),'FontSize',11);
    axis off;

    fprintf('Size      : %dx%d\n',H,W);
    fprintf('TV energy : %.4f\n',tv_energy);
    fprintf('DC ratio  : %.4f\n',dc_ratio);
    fprintf('CS CC     : %.4f\n',cs_cc);

    if tv_energy > 5 && dc_ratio < 3
        fprintf('=> INPUT QUALITY: GOOD for TV-based CS\n');
    else
        fprintf('=> INPUT QUALITY: WEAK / BIASED\n');
    end
end


