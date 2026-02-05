%% FILE 3
clear; close all; clc;

load y_img_NIST_ver1.mat
load img_NIST_ver1.mat

Img = double(imread('cameraman.tif'));
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
A_wrong = orth(randn(size(A,2)))'; 
A_wrong = A_wrong(1:size(A,1),:);

tic
[x_rec, out] = RCoS(A_wrong, b, p, q, opts);
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

mse1 = immse(Img_hat_g(:), Img_g(:));
R = corrcoef(Img_hat_g(:), Img_g(:));
CC = R(1,2);

fprintf('Recon = %.4f | MSE = %.4e | CC = %.6f\n', recon, mse1, CC);

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

%%
% Original image
figure;
imshow(Img_g);
title('Original');
exportgraphics(gcf,'Original_Image.png','Resolution',300);

% Reconstructed image
figure;
imshow(Img_hat_g);
title('Reconstructed');
exportgraphics(gcf,'Reconstructed_NIST_Image.png','Resolution',300);

I = uint8(Img);
Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);

% H-plain
figure;
scatter(Ih(:),Jh(:),5,'.');
title('H-plain');
exportgraphics(gcf,'H_plain.png','Resolution',300);

% V-plain
figure;
scatter(Iv(:),Jv(:),5,'.');
title('V-plain');
exportgraphics(gcf,'V_plain.png','Resolution',300);

% D-plain
figure;
scatter(Id(:),Jd(:),5,'.');
title('D-plain');
exportgraphics(gcf,'D_plain.png','Resolution',300);

R = uint8(Img_hat_g*255);
Rh = R(:,1:end-1);   Rv = R(1:end-1,:);   Rd = R(1:end-1,1:end-1);
Sh = R(:,2:end);     Sv = R(2:end,:);     Sd = R(2:end,2:end);

% H-recon
figure;
scatter(Rh(:),Sh(:),5,'.');
title('H-recon');
exportgraphics(gcf,'H_recon.png','Resolution',300);

% V-recon
figure;
scatter(Rv(:),Sv(:),5,'.');
title('V-recon');
exportgraphics(gcf,'V_recon.png','Resolution',300);

% D-recon
figure;
scatter(Rd(:),Sd(:),5,'.');
title('D-recon');
exportgraphics(gcf,'D_recon.png','Resolution',300);

%%
figPos = [100 100 700 450];
figure('Position',figPos);

subplot(1,2,1)
imshow(Img_g)
set(gca,'Position',[0.06 0.18 0.43 0.72])
text(0.5,-0.10,'(a)','Units','normalized','HorizontalAlignment','center','FontSize',12)

subplot(1,2,2)
imshow(Img_hat_g)
set(gca,'Position',[0.51 0.18 0.43 0.72])
text(0.5,-0.10,'(b)','Units','normalized','HorizontalAlignment','center','FontSize',12)

exportgraphics(gcf,'Image_Comparison.png','Resolution',300);

