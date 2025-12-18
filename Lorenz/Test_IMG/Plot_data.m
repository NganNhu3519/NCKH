close all; clear; clc;

imgH = 64; imgW = 64;

% Img_full = double(imread('riceblurred.png'));
Img_full = double(imread('cell.tif'));
Img = Img_full(1:imgH,1:imgW);

load img_noblock_ver3.mat

x1 = x_est(1,:);
x2 = x_est(2,:);
x3 = x_est(3,:);
z  = x_est(4,:);

C = [1 0 0 0;
     0 1 0 0;
     0 0 0.01 1];

X = [x1(:)'; x2(:)'; x3(:)'; z(:)'];
Y = C * X;

y_cipher = Y(1,:);

M = length(y_cipher);
s = floor(sqrt(M));

idx = randperm(M);
Enc = reshape(y_cipher(idx(1:s*s)), s, s);

figure;

subplot(2,3,1);
scatter(Img(:,1:end-1), Img(:,2:end), 12, '.');
title('(a) Plain – Horizontal');
axis equal; axis tight;

subplot(2,3,2);
scatter(Img(1:end-1,:), Img(2:end,:), 12, '.');
title('(b) Plain – Vertical');
axis equal; axis tight;

subplot(2,3,3);
scatter(Img(1:end-1,1:end-1), Img(2:end,2:end), 12, '.');
title('(c) Plain – Diagonal');
axis equal; axis tight;

subplot(2,3,4);
scatter(Enc(:,1:end-1), Enc(:,2:end), 12, '.');
title('(d) Encrypted – Horizontal');
axis equal; axis tight;

subplot(2,3,5);
scatter(Enc(1:end-1,:), Enc(2:end,:), 12, '.');
title('(e) Encrypted – Vertical');
axis equal; axis tight;

subplot(2,3,6);
scatter(Enc(1:end-1,1:end-1), Enc(2:end,2:end), 12, '.');
title('(f) Encrypted – Diagonal');
axis equal; axis tight;

figure;

subplot(1,2,1);
histogram(Img(:), 64, 'Normalization','probability');
title('Histogram of plain image');
xlabel('Pixel value'); ylabel('Probability');

subplot(1,2,2);
histogram(y_cipher, 64, 'Normalization','probability');
title('Histogram of encrypted signal');
xlabel('Amplitude'); ylabel('Probability');

%%
close all; clear; clc;
format long;

files = {
    'img_0block_ver2.mat', 'ver2';
    'img_0block_ver3.mat', 'ver3';
    'img_0block_ver4.mat', 'ver4'
};

for k = 1:size(files,1)

    fname = files{k,1};
    ver   = files{k,2};
    load(fname)
    fprintf('\n==================== RESULT %s ====================\n', upper(ver));
    fprintf('MSE=%.3e | PSNR=%.2f dB| CC=%f\n',mse_img, peaksnr_img, CC);
end
