%% FILE 1
clear; close all; clc;

Img = double(imread('mri.tif')); % 128x128
[p,q] = size(Img);

block_size = 32;
ratio = 0.5;

projection_matrix_file = ['projections.' num2str(block_size) '.' num2str(ratio) '.mat'];
A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file); %key sensing matrix

x_hat = im2col(Img, [block_size block_size], 'distinct');
y = A * x_hat;
b = y(:);

% save('y_img_Rcos_ver7.mat', ...
%      'b', 'A', 'p', 'q', 'block_size', 'ratio');
% 
% save('y_img_Rcos_ver7_workspace.mat')

x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);

figure;
subplot(1,2,1); imshow(mat2gray(Img)); title('Original image');
subplot(1,2,2); imshow(mat2gray(Img_vis)); title('Encrypted image');

figure;
subplot(2,2,1)
imshow(mat2gray(Img)); axis image;
title('Original image');
subplot(2,2,2)
plot(b,'k');
title('CS measurements b');
subplot(2,2,3)
histogram(Img(:),100);
title('Histogram of original image');
subplot(2,2,4)
histogram(b,100);
title('Histogram of CS measurements');

I = uint8(Img);
Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);
E = uint8(mat2gray(Img_vis)*255);
Eh = E(:,1:end-1);   Ev = E(1:end-1,:);   Ed = E(1:end-1,1:end-1);
Fh = E(:,2:end);     Fv = E(2:end,:);     Fd = E(2:end,2:end);

figure;

subplot(2,3,1)
scatter(Ih(:),Jh(:),1,'.'); axis([0 255 0 255]);
title('(a) H-plain');
subplot(2,3,2)
scatter(Iv(:),Jv(:),1,'.'); axis([0 255 0 255]);
title('(b) V-plain');
subplot(2,3,3)
scatter(Id(:),Jd(:),1,'.'); axis([0 255 0 255]);
title('(c) D-plain');
subplot(2,3,4)
scatter(Eh(:),Fh(:),1,'.'); axis([0 255 0 255]);
title('(d) H-encrypted');
subplot(2,3,5)
scatter(Ev(:),Fv(:),1,'.'); axis([0 255 0 255]);
title('(e) V-encrypted');
subplot(2,3,6)
scatter(Ed(:),Fd(:),1,'.'); axis([0 255 0 255]);
title('(f) D-encrypted');

%% FILE 3
clear; close all; clc;

load y_img_Rcos_ver5.mat
load img_Rcos_ver5.mat

Img = double(imread('mri.tif'));
z = x_est(4,:)';
b = z(:);              

clear opts
opts.mu      = 2^7;
opts.beta    = 2^6;
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

%Test key Phi sensing matrix sai
A_wrong = orth(randn(size(A,2)))'; A_wrong = A_wrong(1:size(A,1),:);

tic
[x_rec, out] = RCoS(A, b, p, q, opts);
recon = toc;

Img_hat = reshape(x_rec, p, q);
Img_hat_g = mat2gray(Img_hat);
Img_g     = mat2gray(Img);

figure;
subplot(1,2,1); 
imshow(Img_g); 
title('Original');
subplot(1,2,2); 
imshow(Img_hat_g); 
title('Reconstructed');

I = uint8(Img);
Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);
figure;
subplot(2,3,1); scatter(Ih(:),Jh(:),1,'.'); axis([0 255 0 255]); title('(a) H-plain');
subplot(2,3,2); scatter(Iv(:),Jv(:),1,'.'); axis([0 255 0 255]); title('(b) V-plain');
subplot(2,3,3); scatter(Id(:),Jd(:),1,'.'); axis([0 255 0 255]); title('(c) D-plain');
R = uint8(Img_hat_g*255);
Rh = R(:,1:end-1);   Rv = R(1:end-1,:);   Rd = R(1:end-1,1:end-1);
Sh = R(:,2:end);     Sv = R(2:end,:);     Sd = R(2:end,2:end);
subplot(2,3,4); scatter(Rh(:),Sh(:),1,'.'); axis([0 255 0 255]); title('(d) H-recon');
subplot(2,3,5); scatter(Rv(:),Sv(:),1,'.'); axis([0 255 0 255]); title('(e) V-recon');
subplot(2,3,6); scatter(Rd(:),Sd(:),1,'.'); axis([0 255 0 255]); title('(f) D-recon');

mse_val = immse(Img_hat_g(:), Img_g(:));
R = corrcoef(Img_hat_g(:), Img_g(:));
CC = R(1,2);

fprintf('Recon = %.4f | MSE = %.4e | CC = %.6f\n', recon, mse_val, CC);

SSIM1 = ssim(Img_hat_g, Img_g);
x = Img_g(:);
y = Img_hat_g(:);
mux = mean(x);
muy = mean(y);
sigx2  = var(x);
sigy2  = var(y);
sigxy  = cov(x,y); 
sigxy  = sigxy(1,2);
Lrange = max(x) - min(x);
c1 = (0.01 * Lrange)^2;
c2 = (0.03 * Lrange)^2;

SSIM2 = ((2*mux*muy + c1)*(2*sigxy + c2)) / ...
               ((mux^2 + muy^2 + c1)*(sigx2 + sigy2 + c2));

fprintf('SSIM (function)=%.6f | SSIM (formula)=%.6f\n', SSIM1, SSIM2);


