%% FILE 1
clear; close all; clc;

Img = double(imread('mri.tif'));
[p,q] = size(Img);

block_size = 32;
ratio = 0.5;

projection_matrix_file = ['projections.' num2str(block_size) '.' num2str(ratio) '.mat'];
A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file);

x_hat = im2col(Img, [block_size block_size], 'distinct');
y = A * x_hat;
b = y(:);

save('y_img_noblock_ver7.mat', ...
     'b', 'A', 'p', 'q', 'block_size', 'ratio');

x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);

figure;
subplot(1,2,1); imshow(uint8(Img));
subplot(1,2,2); imshow(uint8(mat2gray(Img_vis)*255));

%% FILE 3
clear; close all; clc;

load y_img_noblock_ver7.mat
load img_noblock_ver7.mat

Img = double(imread('mri.tif'));
z = x_est(4,:)';
b = z(:);              

clear opts
opts.mu      = 2^8;
opts.beta    = 2^7;
opts.theta   = 1.2;
opts.lambda  = 4;
opts.tol     = 1e-3;
opts.maxit   = 300;

opts.row = p;
opts.col = q;
opts.Org = Img;

opts.block_size = block_size;
opts.ratio      = ratio;

opts.scale_A = true;
opts.scale_b = true;
opts.nonneg  = true;
opts.isreal  = true;

tic
[x_rec, out] = RCoS(A, b, p, q, opts);
recon = toc;

Img_hat = reshape(x_rec, p, q);

figure;
subplot(1,2,1); imshow(uint8(Img)); title('Original');
subplot(1,2,2); imshow(uint8(Img_hat)); title('RCoS + SMO');

mse_val = mean((double(Img(:)) - double(Img_hat(:))).^2);
R = corrcoef(double(Img(:)), double(Img_hat(:)));
CC = R(1,2);

fprintf('Recon = %.4f | MSE = %.4e | CC = %.6f\n', recon, mse_val, CC);
